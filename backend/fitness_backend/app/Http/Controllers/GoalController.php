<?php

namespace App\Http\Controllers;

use App\Models\UserGoal;
use Illuminate\Http\Request;
use Carbon\Carbon;

class GoalController extends Controller
{
    public function saveGoals(Request $request)
    {
        $request->validate([
            'selected_goals' => 'required|array',
            'target_weight' => 'required|numeric'
        ]);

        $userGoals = UserGoal::updateOrCreate(
            ['user_id' => auth()->id()],
            [
                'selected_goals' => $request->selected_goals,
                'target_weight' => $request->target_weight
            ]
        );

        // Calculate daily calorie target using AI
        $calorieTarget = $this->calculateCalorieTarget(
            auth()->user(),
            $request->selected_goals,
            $request->target_weight
        );

        return response()->json([
            'goals' => $userGoals,
            'daily_calorie_target' => $calorieTarget
        ]);
    }

    private function calculateCalorieTarget($user, $goals, $targetWeight)
    {
        $age = $this->calculateAge($user->date_of_birth);
    
        // Base BMR calculation using Mifflin-St Jeor Equation
        $bmr = ($user->gender === 'male')
            ? 88.362 + (13.397 * $user->weight) + (4.799 * $user->height) - (5.677 * $age)
            : 447.593 + (9.247 * $user->weight) + (3.098 * $user->height) - (4.330 * $age);
    
        // Optional: Adjust based on body fat percentage (if available)
        if (isset($user->body_fat_percentage)) {
            $lean_mass = $user->weight * (1 - ($user->body_fat_percentage / 100));
            $bmr = 370 + (21.6 * $lean_mass);
        }
    
        // Activity Level Multipliers (Default: Sedentary)
        $activityLevels = [
            'sedentary' => 1.2,
            'light' => 1.375,
            'moderate' => 1.55,
            'active' => 1.725,
            'very_active' => 1.9
        ];
    
        $activityMultiplier = $activityLevels[$user->activity_level] ?? 1.2;
        $tdee = $bmr * $activityMultiplier; // Total Daily Energy Expenditure
    
        // Adaptive goal adjustments
        if (in_array('lose_weight', $goals)) {
            $deficit = $this->calculateDeficit($user->weight, $targetWeight);
            return $tdee - $deficit; // Adjusted for weight loss
        } elseif (in_array('gain_weight', $goals)) {
            $surplus = $this->calculateSurplus($user->weight, $targetWeight);
            return $tdee + $surplus; // Adjusted for weight gain
        }
    
        return $tdee; // Maintenance calories
    }
    
    // AI-based adaptive deficit calculation for weight loss
    private function calculateDeficit($currentWeight, $targetWeight)
    {
        $weeklyDeficit = min(500 + (0.02 * ($currentWeight - $targetWeight) * 7700), 1000);
        return $weeklyDeficit; // Adaptive based on weight gap
    }
    
    // AI-based adaptive surplus calculation for weight gain
    private function calculateSurplus($currentWeight, $targetWeight)
    {
        $weeklySurplus = min(250 + (0.015 * ($targetWeight - $currentWeight) * 7700), 700);
        return $weeklySurplus; // Adaptive based on weight gain goal
    }
    

    private function calculateAge($dateOfBirth)
    {
        return Carbon::parse($dateOfBirth)->age;
    }
}
