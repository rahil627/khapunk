package com.khapunk.graphics;
import com.khapunk.Graphic;
import com.khapunk.graphics.atlas.AtlasRegion;
import com.khapunk.graphics.atlas.TextureAtlas;
import com.khapunk.graphics.atlas.TileAtlas;
import com.khapunk.graphics.tilemap.AnimatedTile;
import com.khapunk.graphics.tilemap.TileAnimationManager;
import com.khapunk.masks.Grid;
import kha.Canvas;
import kha.Framebuffer;
import kha.graphics2.Graphics;
import kha.Image;
import kha.math.Vector2;
import kha.Rectangle;

typedef Array2D = Array<Array<Int>>

/**
 * A canvas to which Tiles can be drawn for fast multiple tile rendering.
 */
class Tilemap extends Graphic
{

	// Tilemap information.
	private var _rect:Rectangle;
	private var _width:Int;
	private var _height:Int;
	private var _maxWidth:Int;
	private var _maxHeight:Int;
	
	 
	// Tilemap information.
	
	private var _map:Array2D;
	private var _columns:Int;
	private var _rows:Int;

	// Tileset information.
 
	private var _atlas:TileAtlas;
	private var _setColumns:Int;
	private var _setRows:Int;
	private var _setCount:Int;
	private var _tile:Rectangle;
	
	public var animations:Map<Int, AnimatedTile>;
	public var parentAnim:Map<Int, Int>;
	
	public var alpha:Float = 1.0;
	public var hasAnimations:Bool = false;
	public var localAnim(default, null):Bool = false;
	
	/**
	* Scale of the canvas, effects both x and y scale.
	*/
	public var scale:Float = 0;
	
	     /**
	 * If x/y positions should be used instead of columns/rows.
	 */
	public var usePositions:Bool;
	
	/**
	 * Constructor.
	 * @param	tileset				The source tileset image.
	 * @param	width				Width of the tilemap, in pixels.
	 * @param	height				Height of the tilemap, in pixels.
	 * @param	tileWidth			Tile width.
	 * @param	tileHeight			Tile height.
	 * @param	tileSpacingWidth	Tile horizontal spacing.
	 * @param	tileSpacingHeight	Tile vertical spacing.
	 */
	public function new(tileset:Dynamic, width:Int, height:Int, tileWidth:Int, tileHeight:Int, ?tileSpacingWidth:Int=0, ?tileSpacingHeight:Int=0)
	{
	
		super();
		_rect = KP.rect;
		// set some tilemap information
		_width = width - (width % tileWidth);
		_height = height - (height % tileHeight);
		_columns = Std.int(_width / tileWidth);
		_rows = Std.int(_height / tileHeight);

		this.tileSpacingWidth = tileSpacingWidth;
		this.tileSpacingHeight = tileSpacingHeight;

		if (_columns == 0 || _rows == 0)
			throw "Cannot create a bitmapdata of width/height = 0";

		// create the canvas
/*#if neko
		_maxWidth = 4000 - 4000 % tileWidth;
		_maxHeight = 4000 - 4000 % tileHeight;
#else*/
		_maxWidth -= _maxWidth % tileWidth;
		_maxHeight -= _maxHeight % tileHeight;
//#end

		

		// initialize map
		_tile = new Rectangle(0, 0, tileWidth, tileHeight);
		_map = new Array2D();
		for (y in 0..._rows)
		{
			_map[y] = new Array<Int>();
			for (x in 0..._columns)
			{
				_map[y][x] = -1;
			}
		}

		if (Std.is(tileset,TileAtlas))
		{
			_atlas =  cast(tileset, TileAtlas);
		}
		else {
		
			_atlas = TileAtlas.getAtlas(tileset,tileWidth, tileHeight, tileSpacingWidth, tileSpacingHeight);
		}
		

		if (_atlas == null)
			throw "Invalid tileset graphic provided.";
		else
		{
			_setColumns = Std.int(_atlas.imgWidth / tileWidth);
			_setRows = Std.int(_atlas.imgHeight / tileHeight);
		}
		_setCount = _setColumns * _setRows;
	}
	
	public function numColInTileset() : Int
	{
		return _atlas.cols;
	}
	
	public function numRowInTileset() : Int
	{
		return _atlas.rows;
	}
	
	/**
	 * Sets the index of the tile at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 * @param	index		Tile index.
	 */
	public function setTile(column:Int, row:Int, index:Int = 0)
	{
		
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
		}
		index %= _setCount;
		column %= _columns;
		row %= _rows;
		_map[row][column] = index;
		
	}
	
	/**
	 * Clears the tile at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 */
	public function clearTile(column:Int, row:Int)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
		}
		column %= _columns;
		row %= _rows;
		_map[row][column] = -1;
	}
	
	/**
	 * Gets the tile index at the position.
	 * @param	column		Tile column.
	 * @param	row			Tile row.
	 * @return	The tile index.
	 */
	public function getTile(column:Int, row:Int):Int
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
		}
		return _map[row % _rows][column % _columns];
	}
	
	/**
	 * Sets a rectangular region of tiles to the index.
	 * @param	column		First tile column.
	 * @param	row			First tile row.
	 * @param	width		Width in tiles.
	 * @param	height		Height in tiles.
	 * @param	index		Tile index.
	 */
	public function setRect(column:Int, row:Int, width:Int = 1, height:Int = 1, index:Int = 0)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
			width = Std.int(width / _tile.width);
			height = Std.int(height / _tile.height);
		}
		column %= _columns;
		row %= _rows;
		var c:Int = column,
			r:Int = column + width,
			b:Int = row + height,
			u:Bool = usePositions;
		usePositions = false;
		while (row < b)
		{
			while (column < r)
			{
				setTile(column, row, index);
				column ++;
			}
			column = c;
			row ++;
		}
		usePositions = u;
	}
	
	/**
	 * Clears the rectangular region of tiles.
	 * @param	column		First tile column.
	 * @param	row			First tile row.
	 * @param	width		Width in tiles.
	 * @param	height		Height in tiles.
	 */
	public function clearRect(column:Int, row:Int, width:Int = 1, height:Int = 1)
	{
		if (usePositions)
		{
			column = Std.int(column / _tile.width);
			row = Std.int(row / _tile.height);
			width = Std.int(width / _tile.width);
			height = Std.int(height / _tile.height);
		}
		column %= _columns;
		row %= _rows;
		var c:Int = column,
			r:Int = column + width,
			b:Int = row + height,
			u:Bool = usePositions;
		usePositions = false;
		while (row < b)
		{
			while (column < r)
			{
				clearTile(column, row);
				column ++;
			}
			column = c;
			row ++;
		}
		usePositions = u;
	}
	
	/**
	 * Set the tiles from an array.
	 * The array must be of the same size as the Tilemap.
	 *
	 * @param	array	The array to load from.
	 */
	public function loadFrom2DArray(array:Array2D):Void
	{
		_map = array;
	}
	
	
	/**
	* Loads the Tilemap tile index data from a string.
	* The implicit array should not be bigger than the Tilemap.
	* @param str			The string data, which is a set of tile values separated by the columnSep and rowSep strings.
	* @param columnSep		The string that separates each tile value on a row, default is ",".
	* @param rowSep			The string that separates each row of tiles, default is "\n".
	*/
	public function loadFromString(str:String, columnSep:String = ",", rowSep:String = "\n")
	{
		var row:Array<String> = str.split(rowSep),
			rows:Int = row.length,
			col:Array<String>, cols:Int, x:Int, y:Int;
		for (y in 0...rows)
		{
			if (row[y] == '') continue;
			col = row[y].split(columnSep);
			cols = col.length;
			for (x in 0...cols)
			{
				if (col[x] == '') continue;
				_map[y][x] = Std.parseInt(col[x]);
			}
		}
	}
	
	/**
	* Saves the Tilemap tile index data to a string.
	* @param columnSep		The string that separates each tile value on a row, default is ",".
	* @param rowSep			The string that separates each row of tiles, default is "\n".
	*
	* @return	The string version of the array.
	*/
	public function saveToString(columnSep:String = ",", rowSep:String = "\n"): String
	{
		var s:String = '',
			x:Int, y:Int;
		for (y in 0..._rows)
		{
			for (x in 0..._columns)
			{
				s += Std.string(getTile(x, y));
				if (x != _columns - 1) s += columnSep;
			}
			if (y != _rows - 1) s += rowSep;
		}
		return s;
	}
	
	/**
	 * Gets the index of a tile, based on its column and row in the tileset.
	 * @param	tilesColumn		Tileset column.
	 * @param	tilesRow		Tileset row.
	 * @return	Index of the tile.
	 */
	public inline function getIndex(tilesColumn:Int, tilesRow:Int):Int
	{
		return (tilesRow % _setRows) * _setColumns + (tilesColumn % _setColumns);
	}
	
	
	/**
	 * Shifts all the tiles in the tilemap.
	 * @param	columns		Horizontal shift.
	 * @param	rows		Vertical shift.
	 * @param	wrap		If tiles shifted off the canvas should wrap around to the other side.
	 */
	public function shiftTiles(columns:Int, rows:Int, wrap:Bool = false)
	{
		if (usePositions)
		{
			columns = Std.int(columns / _tile.width);
			rows = Std.int(rows / _tile.height);
		}

		if (columns != 0)
		{
			for (y in 0..._rows)
			{
				var row = _map[y];
				if (columns > 0)
				{
					for (x in 0...columns)
					{
						var tile:Int = row.pop();
						if (wrap) row.unshift(tile);
					}
				}
				else
				{
					for (x in 0...Std.int(Math.abs(columns)))
					{
						var tile:Int = row.shift();
						if (wrap) row.push(tile);
					}
				}
			}
			_columns = _map[Std.int(y)].length;

/*#if flash
			shift(Std.int(columns * _tile.width), 0);
			_rect.x = columns > 0 ? 0 : _columns + columns;
			_rect.y = 0;
			_rect.width = Math.abs(columns);
			_rect.height = _rows;
			updateRect(_rect, !wrap);
#end*/
		}

		if (rows != 0)
		{
			if (rows > 0)
			{
				for (y in 0...rows)
				{
					var row:Array<Int> = _map.pop();
					if (wrap) _map.unshift(row);
				}
			}
			else
			{
				for (y in 0...Std.int(Math.abs(rows)))
				{
					var row:Array<Int> = _map.shift();
					if (wrap) _map.push(row);
				}
			}
			_rows = _map.length;

/*#if flash
			shift(0, Std.int(rows * _tile.height));
			_rect.x = 0;
			_rect.y = rows > 0 ? 0 : _rows + rows;
			_rect.width = _columns;
			_rect.height = Math.abs(rows);
			updateRect(_rect, !wrap);
#end*/
		}
	}
	
	/** @private Used by shiftTiles to update a rectangle of tiles from the tilemap. */
	private function updateRect(rect:Rectangle, clear:Bool)
	{
		var x:Int = Std.int(rect.x),
			y:Int = Std.int(rect.y),
			w:Int = Std.int(x + rect.width),
			h:Int = Std.int(y + rect.height),
			u:Bool = usePositions;
		usePositions = false;
		if (clear)
		{
			while (y < h)
			{
				while (x < w) clearTile(x ++, y);
				x = Std.int(rect.x);
				y ++;
			}
		}
		else
		{
			while (y < h)
			{
				while (x < w) updateTile(x ++, y);
				x = Std.int(rect.x);
				y ++;
			}
		}
		usePositions = u;
	}
	
	override public function render(buffer:Canvas, point:Vector2, camera:Vector2)
	{
		
		material.Apply(buffer);
		
		// determine drawing location
		this.point.x = point.x + x - camera.x * scrollX;
		this.point.y = point.y + y - camera.y * scrollY;


		/*
		var scalex:Float = KP.screen.fullScaleX, scaley:Float = KP.screen.fullScaleY,
			tw:Int = Math.ceil(tileWidth), th:Int = Math.ceil(tileHeight);
*/

		var tw:Int = Math.ceil(tileWidth); 
		var th:Int = Math.ceil(tileHeight);

		// determine start and end tiles to draw (optimization)
		var startx = Math.floor( - this.point.x / tw),
			starty = Math.floor( - this.point.y / th),
			destx = startx + 1 + Math.ceil(KP.width / tw),
			desty = starty + 1 + Math.ceil(KP.height / th);

		// nothing will render if we're completely off screen
		if (startx > _columns || starty > _rows || destx < 0 || desty < 0)
			return;

		// clamp values to boundaries
		if (startx < 0) startx = 0;
		if (destx > _columns) destx = _columns;
		if (starty < 0) starty = 0;
		if (desty > _rows) desty = _rows;

		/*	var wx:Float, sx:Float = (_point.x + startx * tw * scx) * scalex,
			wy:Float = (_point.y + starty * th * scy) * scaley,
			stepx:Float = tw * scx * scalex,
			stepy:Float = th * scy * scaley,
			tile:Int = 0;
		*/
			
		var wx:Float;
		var sx:Float = ( Math.floor(this.point.x) + startx * tw );
		var	wy:Float = ( Math.floor(this.point.y) + starty * th );
		var	stepx:Float = tw;
		var	stepy:Float = th;
		var	tile:Int = 0;
	
		// adjust scale to fill gaps
		//scx = Math.ceil(stepx) / tileWidth;
		//scy = Math.ceil(stepy) / tileHeight;
		
		
		buffer.g2.set_opacity(alpha);
		var tr:AtlasRegion;
		var parent:Int;
		var animation:AnimatedTile;
		var offset:Int = 0;
		for (y in starty...desty)
		{
			wx = sx;
			
			for (x in startx...destx)
			{
				tile = _map[y % _rows][x % _columns];
				
				if (tile < 0) {
					wx += stepx;
					continue;
				}
				
				if (hasAnimations) {
					
					if (animations.exists(tile)) {
						animation = animations.get(tile);
						tile =  animation.getParentFrame();
					}
					else if (parentAnim.exists(tile)) {	
						
						parent = parentAnim.get(tile);
						animation = animations.get(parent);
						tile = animation.getChildFrame(tile);
					}
				}
				tr = _atlas.getRegion(tile);
				buffer.g2.drawScaledSubImage(_atlas.img, tr.x, tr.y, tr.w, tr.h,wx, wy, _tile.width, _tile.height);
					//_atlas.prepareTile(tile, Std.int(wx), Std.int(wy), layer, scx, scy, 0, _red, _green, _blue, alpha);
				wx += stepx;
			}
			wy += stepy;
		}
		buffer.g2.set_opacity(1);
	}
	
	/**
	 * Create a Grid object from this tilemap.
	 * @param solidTiles	Array of tile indexes that should be solid.
	 * @param grid			A grid to use instead of creating a new one, the function won't check if the grid is of correct dimension.
	 * @return The grid with a tile solid if the tile index is in [solidTiles].
	*/
	public function createGrid(solidTiles:Array<Int>, ?grid:Grid)
	{
		if (grid == null)
		{
			grid = new Grid(_width, _height, Std.int(_tile.width), Std.int(_tile.height));
		}
		
		for (y in 0..._rows)
		{
			for (x in 0..._columns)
			{
				if (solidTiles.indexOf(getTile(x, y)) != -1)
				{
					grid.setTile(x, y, true);
				}
			}
		}
		
		return grid;
	}
	
	
	/**
	 * Adds animation information for a tile
	 * @param	index The tile index
	 * @param	length The amount of frames 
	 * @param	speed The rate at which the tile should animate
	 * @param	reverse Whether the animation should be played backwards
	 * @param	vertical If our animation is setup vertical on our tileset.
	 * @return  returns The object that holds the animation information.
	 */
	public function addAnimatedTile(index:Int, frames:Array<Int>, durations:Array<Float>, tileset:String,speed:Int = 1, reverse:Bool = false) : AnimatedTile
	{	
		var anim:AnimatedTile;
		if (animations.exists(index)) {
			anim = animations.get(index);
		}
		else {
			anim = new AnimatedTile();
			anim.index = index;
			animations.set(index, anim);
		}
	
		//TODO copy values?
		anim.frames = frames;
		anim.durations = durations;
		anim.reverse = reverse;
		anim.speed = speed;
		anim.length = frames.length;
		anim.frameTimers[0] = 0;
		anim.framePos[0] = 0;
		return anim;
	}
	
	/**
	 * Groups up an animation frame to a parent frame
	 * @param	index The child GID
	 * @param	parent The parent GID.
	 */
	public function addChildTile(index:Int, parent:Int, tileset:String) : Void
	{
		 parentAnim.set(index, parent);
		 var l:Int = animations.get(parent).framePos.length;
		 animations.get(parent).framePos[l] = l;
		 animations.get(parent).frameTimers[l] = 0.0;
	}

	
	public function initAnims(tileset:String, local:Bool = false): Void
	{
		localAnim = local;
		if (localAnim) {
			if(animations == null)
			animations = new Map<Int, AnimatedTile>();
			if (parentAnim == null)
			parentAnim = new Map<Int, Int>();
		}
		else{
			if (!TileAnimationManager.layerExists(tileset))
			{
				animations = new Map<Int, AnimatedTile>();
				TileAnimationManager.addLayer(tileset, animations);
			}
			else if(animations == null)
			{
				animations =  TileAnimationManager.getLayer(tileset);
			}
			
			if (!TileAnimationManager.parentLayerExists(tileset))
			{
				parentAnim = new Map<Int, Int>();
				TileAnimationManager.addParentLayer(tileset, parentAnim);
			}
			else if(parentAnim == null)
			{
				parentAnim = TileAnimationManager.getParentLayer(tileset);
			}
		}
	}
	
	override public function update() 
	{
		if (localAnim)
		for (anim in animations)
		{
			anim.update();
		}
	}
	
	/** @private Used by shiftTiles to update a tile from the tilemap. */
	private function updateTile(column:Int, row:Int)
	{
		setTile(column, row, _map[row % _rows][column % _columns]);
	}

	/**
	 * The tile width.
	 */
	public var tileWidth(get, never):Int;
	private inline function get_tileWidth():Int { return Std.int(_tile.width); }

	/**
	 * The tile height.
	 */
	public var tileHeight(get, never):Int;
	private inline function get_tileHeight():Int { return Std.int(_tile.height); }

	/**
	 * The tile horizontal spacing of tile.
	 */
	public var tileSpacingWidth(default, null):Int;

	/**
	 * The tile vertical spacing of tile.
	 */
	public var tileSpacingHeight(default, null):Int;

	/**
	 * How many tiles the tilemap has.
	 */
	public var tileCount(get, never):Int;
	private inline function get_tileCount():Int { return _setCount; }

	/**
	 * How many columns the tilemap has.
	 */
	public var columns(get, null):Int;
	private inline function get_columns():Int { return _columns; }

	/**
	 * How many rows the tilemap has.
	 */
	public var rows(get, null):Int;
	private inline function get_rows():Int { return _rows; }

	
}

