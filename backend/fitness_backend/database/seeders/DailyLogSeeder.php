<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use App\Models\DailyLog;
use App\Models\User;
use Illuminate\Database\Seeder;
use Carbon\Carbon;

class DailyLogSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $users = User::all();
        $startDate = Carbon::now()->subDays(30);

        foreach ($users as $user) {
            // Create 30 days of logs for each user
            for ($i = 0; $i < 30; $i++) {
                $date = $startDate->copy()->addDays($i);
                
                // Generate realistic daily variations
                $baseCalories = match($user->id) {
                    1 => 2000, // John's base calories
                    2 => 1800, // Jane's base calories
                    3 => 2500, // Mike's base calories
                    default => 2000
                };

                // Add some random variation to make data more realistic
                DailyLog::create([
                    'user_id' => $user->id,
                    'calories_consumed' => $baseCalories + rand(-200, 200),
                    'calories_burned' => rand(200, 500),
                    'steps_taken' => rand(6000, 12000),
                    'log_date' => $date,
                    'created_at' => $date,
                    'updated_at' => $date
                ]);
            }
        }
    }
}
