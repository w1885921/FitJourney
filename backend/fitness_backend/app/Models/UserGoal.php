<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserGoal extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'selected_goals',
        'target_weight'
    ];

    protected $casts = [
        'selected_goals' => 'array',
        'target_weight' => 'float'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
