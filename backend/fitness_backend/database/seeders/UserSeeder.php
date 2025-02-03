<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;


class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Create test users with different profiles
        $users = [
            [
                'full_name' => 'John Doe',
                'email' => 'john@example.com',
                'password' => Hash::make('password123'),
                'date_of_birth' => '1990-01-15',
                'mobile_number' => '+1234567890',
                'weight' => 75.5,
                'height' => 175.0,
                'gender' => 'male'
            ],
            [
                'full_name' => 'Jane Smith',
                'email' => 'jane@example.com',
                'password' => Hash::make('password123'),
                'date_of_birth' => '1992-03-20',
                'mobile_number' => '+1987654321',
                'weight' => 62.0,
                'height' => 165.0,
                'gender' => 'female'
            ],
            [
                'full_name' => 'Mike Johnson',
                'email' => 'mike@example.com',
                'password' => Hash::make('password123'),
                'date_of_birth' => '1988-07-10',
                'mobile_number' => '+1122334455',
                'weight' => 85.0,
                'height' => 180.0,
                'gender' => 'male'
            ]
        ];

        foreach ($users as $user) {
            User::create($user);
        }
    }
}
