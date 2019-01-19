<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
class Addresses extends Model
{
    //
    public $timestamps = false;
    public function user(){
        return $this->belongsTo(User::class);
    }
}
