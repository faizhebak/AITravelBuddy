<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Destination;

class DestinationController extends Controller
{
    public function index()
    {
        $items = Destination::select('id','name','description','image_url')->get();
        return response()->json($items);
    }

    public function show($id)
    {
        $item = Destination::findOrFail($id);
        return response()->json($item);
    }
}
