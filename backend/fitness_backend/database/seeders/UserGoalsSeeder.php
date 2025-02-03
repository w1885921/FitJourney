<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\UserGoal;
use App\Models\User;
use Illuminate\Database\Seeder;

class UserGoalsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Sample goals for each user
        $users = User::all();

        foreach ($users as $user) {
            $goalTypes = [
                1 => ['lose_weight', 'improve_fitness'],
                2 => ['gain_weight', 'build_muscle'],
                3 => ['maintain_weight', 'better_sleep']
            ];

            $targetWeights = [
                1 => 70.0,  // John wants to lose weight
                2 => 65.0,  // Jane wants to gain muscle
                3 => 85.0   // Mike wants to maintain
            ];

            UserGoal::create([
                'user_id' => $user->id,
                'selected_goals' => $goalTypes[$user->id],
                'target_weight' => $targetWeights[$user->id]
            ]);
        }
    }
}
