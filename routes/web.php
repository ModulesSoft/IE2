<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

//for vue route
Route::get('/', function () {return view('welcome');});
Route::get('/users', function (){return view('welcome');});
Route::get('/product/{id}', function (){return view('welcome');});
Route::get('/start',function (){return view('welcome');});
Route::get('/design',function (){return view('welcome');})->middleware('auth');
Route::get('/profile/{id}',function (){return view('welcome');})->middleware('auth');


//API
Route::post('/updateOnlines','HomeController@updateOnlines');
Route::get('/getOnlines','HomeController@getOnlines');
Route::post('/getOnline','HomeController@getOnline');
Route::get('/getUsers','HomeController@getUsers');
Route::post('/editUser','HomeController@editUser');

Route::post('/confirmGameComment','HomeController@confirmGameComment');
Route::get('/getGamesComments/{id?}','HomeController@getGamesComments');
Route::post('/confirmUserComment','HomeController@confirmUserComment');
Route::get('/getUsersComments/{id?}','HomeController@getUsersComments');
Route::post('/setUserComment/','HomeController@setUserComment');
Route::post('/setGameComment/','HomeController@setGameComment');
Route::post('/getMyComments/','HomeController@getMyComments');

Route::post('/setUser','HomeController@setUser');
Route::post('/editUser','HomeController@editUser');
Route::get('/profile/getUser/{username}','HomeController@getUser');

Route::post('/designGame','HomeController@designGame');
Route::get('/getGames','HomeController@getGames');

Route::post('/initialGame','HomeController@initialGame');
Route::post('/myMoves','HomeController@myMoves');
Route::post('/getMoves','HomeController@getMoves');


Route::get('logout', '\App\Http\Controllers\Auth\LoginController@logout');
Route::post('login', function (Request $request) {
    if (auth()->attempt(['username' => $request->input('username'), 'password' => $request->input('password')])) {
        // Authentication passed...
        $user = auth()->user();
//        $user->api_token = str_random(60);
        $user->save();
        return $user;
    }

    return response()->json([
        'error' => 'Unauthenticated user',
        'code' => 401,
    ], 401);
});