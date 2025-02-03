<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DailyLog extends Model
{
    use HasFactory;
    protected $fillable = [
        'user_id',
        'calories_consumed',
        'calories_burned',
        'steps_taken',
        'log_date'
    ];

    protected $casts = [
        'log_date' => 'date',
        'calories_consumed' => 'integer',
        'calories_burned' => 'integer',
        'steps_taken' => 'integer'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
