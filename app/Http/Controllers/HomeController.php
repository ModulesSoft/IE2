<?php

namespace App\Http\Controllers;

use App\Addresses;
use App\CategoriesProducts;
use App\Design;
use App\Game;
use App\games_comments;
use App\Onlines;
use App\ProductsImages;
use App\ProductsSizes;
use App\User;
use App\users_comments;
use App\waitlist;
use Carbon\Carbon;
use Illuminate\Support\Facades\DB;
use App\Orders;
use App\OrdersProducts;
use App\Products;
use App\ProductsColors;
use Illuminate\Support\Facades\Hash;
use Request;
use App\Categories;
use Illuminate\Support\Facades\Input;
use function Sodium\add;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
//        $this->middleware('auth');
    }

    public function getMyComments(Request $request)
    {
        $whom_id = User::where('username', $request::get('username'))->first()->id;
        return users_comments::where('whom_id', $whom_id)->where('confirmed', 1)->get();
    }

    public function setGameComment(Request $request)
    {
        $user_id = User::where('username', $request::get('username'))->first()->id;
        $design_id = $request::get('design_id');
        $text = $request::get('text');
        $gameComment = new games_comments;
        $gameComment->user_id = $user_id;
        $gameComment->text = $text;
        $gameComment->design_id = $design_id;
        $gameComment->save();
        return 'ok';
    }

    public function setUserComment(Request $request)
    {
        $user_id = $request::get('imUser');
        $whom_id = User::where('username', $request::get('whom'))->first()->id;
        $text = $request::get('text');
        $userComment = new users_comments;
        $userComment->user_id = $user_id;
        $userComment->text = $text;
        $userComment->whom_id = $whom_id;
        $userComment->save();
        return 'ok';
    }

    public function myMoves(Request $request)
    {
        $gameId = $request::get('gameId');
        $username = $request::get('username');
        $current = $request::get('current');
        $global = $request::get('global');
        $user = $request::get('user');
        $dice = $request::get('dice');
        $game = Game::where('id', $gameId)->first();
        //giving competitor's information
        if ($user == 1) {
            $game->global1 = $global;
            $game->current1 = $current;
        } else {
            $game->global2 = $global;
            $game->current2 = $current;
        }
        //checking finished game
        $design = Design::where('id', $game->design_id)->first();
        if ($design->max_point <= $game->global1) {
            $game->finished = 1;
        } elseif ($design->max_point <= $game->global2) {
            $game->finished = 2;
        }
        //changing turns
        if ($game->turn == 2) {
            $game->turn = 1;
        } else {
            $game->turn = 2;
        }

        $game->dice = $dice;
        $game->save();
        return "ok";
    }

    public function getMoves(Request $request)
    {
        //who asks:
        $user = $request::get('user');
        $username = $request::get('username');
        $gameId = $request::get('gameId');
        return Game::where('id', $gameId)->first();
    }

    public function initialGame(Request $request)
    {
        $id = $request::get('id');
        $username = $request::get('username');
        $game = Game::where('design_id', $id)->where('finished', 0)->first();
        if ($game) {
            if ($game->user1 && $game->user2) {//all users are present
                $design = Design::where('id', $id)->first();
                $game->max_point = $design->max_point;
                $game->dice_number = $design->dice_number;
                $game->max_dice = $design->max_dice;
                $game->zero1 = $design->zero1;
                $game->zero2 = $design->zero2;
                $game->zero3 = $design->zero3;
                $game->zero4 = $design->zero4;
                $game->zero5 = $design->zero5;
                $game->zero6 = $design->zero6;
                return $game;
            } else {
                if ($game->user1 != $username) {//second user came
                    $game->user2 = $username;
                    $game->save();
                    return 'wait2';
                } else {//second user not came
                    if (Carbon::now()->diffInMinutes($game->created_at) > 2) {
                        $game->delete();
                        return 'cancel';
                    }
                    return 'wait2';
                }
            }
        } else {
            //new game
            $game = new Game;
            $game->user1 = $username;
            $game->design_id = $id;
            $game->save();
            return 'wait1';
        }

//        $waitlist = waitlist::where('design_id', $id)->first();
//        if ($waitlist) {
//            if ($waitlist->user1 == $username) {//someone is checking list of the game and see's himself
//                if (Carbon::now()->diffInMinutes($waitlist->created_at) > 2) {
//                    $waitlist->delete();
//                    return 'cancel';
//                }
//                return 'wait1';
//            } else {
//                //else
//                //make game
//                $game = new Game;
//                $game->design_id = $id;
//                $game->user1 = $waitlist->user1;
//                $game->user2 = $username;
//                $game->save();
//                //delete waitlisted
//                $waitlist->delete();
//                $design = Design::where('id', $id)->first();
//                $game->max_point = $design->max_point;
//                $game->dice_number = $design->dice_number;
//                $game->max_dice = $design->max_dice;
//                $game->zero1 = $design->zero1;
//                $game->zero2 = $design->zero2;
//                $game->zero3 = $design->zero3;
//                $game->zero4 = $design->zero4;
//                $game->zero5 = $design->zero5;
//                $game->zero6 = $design->zero6;
//                return $game;
//            }
//        } else {
//            //go to waitlist
//            $waitlist = new waitlist;
//            $waitlist->user1 = $username;
//            $waitlist->design_id = $id;
//            $waitlist->save();
//            return 'wait2';
//        }
    }

    public function getGames()
    {
        $design = Design::all();
        $games = [];
        foreach ($design as $d) {
            $game = Game::where('design_id', $d->id);
            $count = 0;//
            $sum = 0;
            $online = 0;//
            foreach ($game as $g) {
                $count++;
                $sum = $g->global1 + $g->global2;
                if ($g->finished == 0) {
                    $online++;
                }
            }
//            $name = $d->name;//
//            $average = $sum/$count;//
//            $date = $d->created_at;//
//            $username = $d->username;//
            $d->online = $online;
            $d->count = $count;
            if ($count == 0)
                $d->average = 0;
            else
                $d->average = $sum / $count;
        }
        return $design;
    }

    public function designGame(Request $request)
    {
        $design = new Design;
        $design->name = $request::get('name');
        $design->username = $request::get('username');
        $design->max_point = $request::get('max_point');
        $design->dice_number = $request::get('dice_number');
        $design->max_dice = $request::get('max_dice');
        $design->zero1 = $request::get('zero1');
        $design->zero2 = $request::get('zero2');
        $design->zero3 = $request::get('zero3');
        $design->zero4 = $request::get('zero4');
        $design->zero5 = $request::get('zero5');
        $design->zero6 = $request::get('zero6');
        $design->save();
        return 'ok';
    }

    public function getUsers()
    {
        return User::all();
    }

    public function getUser($username)
    {
        return User::where('username', $username)->first();
    }

    public function getOnline(Request $request)
    {
        return Onlines::where('username', '=', $request::get('username'))->first();
    }

    public function getUsersComments($id = null)
    {
        if ($id) {

        } else {
            return users_comments::all();
        }
    }

    public function getGamesComments($id = null)
    {
        if ($id) {
            $comments = games_comments::where('design_id', $id)->where('confirmed', 1)->get();
            foreach ($comments as $c) {
                $us = User::find($c->user_id)->first();
                $c->username = $us->username;
            }
            return $comments;
        } else {
            return games_comments::all();
        }
    }

    public function confirmUserComment(Request $request)
    {
        $id = $request::get("id");
        $uc = users_comments::find($id);
        $uc->confirmed = 1;
        $uc->save();
        return 'ok';
    }

    public
    function confirmGameComment(Request $request)
    {
        $id = $request::get("id");
        $uc = games_comments::find($id);
        $uc->confirmed = 1;
        $uc->save();
        return 'ok';
    }

    public
    function updateOnlines(Request $request)
    {
        $remove = $request::get("remove");
        $add = $request::get("add");
        if (isset($remove)) {
            $ou = Onlines::where('username', '=', $remove);
            $ou->delete();
            return 'ok';
        } elseif (isset($add)) {
//            $ou = new Onlines;
//            $ou->username = $add;
//            $ou->save();
            DB::table('onlines')->insert(
                array('username' => $add)
            );
            return 'ok';
        }
        return 'nok';
    }

    public
    function getOnlines()
    {
        return Onlines::all();
    }


    public
    function setUser(Request $request)
    {
        $username = $request::get('username');
        $name = $request::get('name');
        $password = Hash::make($request::get('password'));
        $avatarURL = $request::get('avatarURL');
        $email = $request::get('email');
        $point = 0;
        if (isset($username)) {
            if (isset($password)) {
                $users = new User;
                if (isset($avatarURL)) {
                    $users->avatarURL = $avatarURL;
                }
                $users->name = $name;
                $users->email = $email;
                $users->username = $username;
                $users->password = $password;
                $users->point = $point;
                $users->save();
                return "ok";
            } else {
                return "nok1";
            }
        } else {
            return "nok2";
        }
    }

    public
    function editUser(Request $request)
    {
        $username = $request::get('username');
        if ($request::get('point') && $username) { // this is for update points
            $point = $request::get('point');
            $users = User::where('username', $username)->first();
            $users->point = $users->point + $point;
            $users->save();
            return 'ok';
        }
        $password = Hash::make($request::get('password'));
        $avatarURL = $request::get('avatarURL');

        $users = User::where('username', $username)->first();
        $users->password = $password;
//        $users->avatarURL = $avatarURL;
        $users->save();
        return "ok";

    }

}
