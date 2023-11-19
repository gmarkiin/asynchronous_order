<?php

declare(strict_types=1);

namespace App\Model;

use Hyperf\DbConnection\Model\Model;

/**
 * @property string $id 
 * @property string $name 
 * @property string $wallet 
 * @property \Carbon\Carbon $createdAt 
 * @property \Carbon\Carbon $updatedAt 
 */
class Client extends Model
{
    /**
     * The table associated with the model.
     */
    protected ?string $table = 'clients';

    /**
     * The attributes that are mass assignable.
     */
    protected array $fillable = [];

    /**
     * The attributes that should be cast to native types.
     */
    protected array $casts = ['created_at' => 'datetime', 'updated_at' => 'datetime'];
}
