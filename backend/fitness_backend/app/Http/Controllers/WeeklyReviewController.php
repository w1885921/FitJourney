<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DailyLog;

class WeeklyReviewController extends Controller
{
    public function getWeeklyReview()
{
    $user = auth()->user()->load('goals'); // Eager load the user goals
    // dd($user->goals);

    if (!$user->goals) {
        return response()->json(['message' => 'User goals not found'], 404);
    }

    // If goals exist, proceed with the logic
    $endDate = now();
    $startDate = now()->subDays(7);

    $weeklyLogs = DailyLog::where('user_id', auth()->id())
        ->whereBetween('log_date', [$startDate, $endDate])
        ->get();

    $totalCaloriesConsumed = $weeklyLogs->sum('calories_consumed');
    $totalCaloriesBurned = $weeklyLogs->sum('calories_burned');
    $totalSteps = $weeklyLogs->sum('steps_taken');

    // AI-based insights
    $insights = $this->generateInsights(
        $weeklyLogs,
        $user->goals
    );

    return response()->json([
        'total_calories_consumed' => $totalCaloriesConsumed,
        'total_calories_burned' => $totalCaloriesBurned,
        'total_steps' => $totalSteps,
        'daily_logs' => $weeklyLogs,
        'insights' => $insights
    ]);
}

    private function generateInsights($logs, $goals)
    {
        $insights = [];
        
        // Check if the goals are null or empty
        if (!$goals) {
            $insights[] = "No user goals found. Please update your goals to get personalized insights.";
            return $insights;
        }
    
        // Example AI-based insight generation
        $avgDailyCalories = $logs->avg('calories_consumed');
        $targetCalories = $goals->daily_calorie_target;
    
        if ($avgDailyCalories > $targetCalories * 1.1) {
            $insights[] = "You're consistently eating above your calorie target. Try reducing portion sizes.";
        } elseif ($avgDailyCalories < $targetCalories * 0.9) {
            $insights[] = "You're eating below your calorie target. This might affect your energy levels.";
        }
    
        return $insights;
    }
}
