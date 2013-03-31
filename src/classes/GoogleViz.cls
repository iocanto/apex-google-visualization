public class GoogleViz {

	public static final String COL_BOOLEAN = 'boolean';
	public static final String COL_DATE = 'date';
	public static final String COL_DATETIME = 'datetime';
	public static final String COL_NUMBER = 'number';
	public static final String COL_STRING = 'string';
	public static final String COL_TIMEOFDAY = 'timeofday';

	public List<Col> cols = new List<Col>();
	public List<row> rows = new list<row>{};

	/*
	Column structure:
	Each column is an object, containing the following properties:
	* id:
		- String.
		- Optional.
		- This is the id of the column. Should be unique in this data table.
		  Preferably be simple (alphanumeric) so later on you don't have to escape it with backticks when you refer to it.

	* label:
		- String.
		- Optional.
		This is the label of the column, and some visualizations (like table, and some charts) actually display it to the users.

	* type
	   - String.
	   - Mandatory.
	   - This is the type of this column, must be from one of the following gviz types:
				'boolean' - JavaScript boolean value ('true' or 'false'). Example value: v:'true'
				'number' - JavaScript number value. Example values: v:7 , v:3.14, v:-55
				'string' - JavaScript string value. Example value: v:'hello'
				'date' - JavaScript Date object (zero-based month), with the time truncated. Example value: v:new Date(2008, 0, 15)
				'datetime' - JavaScript Date object including the time. Example value: v:new Date(2008, 0, 15, 14, 30, 45)
				'timeofday' - Array of three numbers and an optional fourth, representing hour (0 indicates midnight), minute, second,
				and optional millisecond. Example values: v:[8, 15, 0], v: [6, 12, 1, 144]
	*/
 	public class Col {

	    public string id;
	    public string label;
	    public string type;

 		/*
 			Constructors
 		*/
    	public Col() { this( null ); }
    	public Col(string idd ) { this ( idd, null ); }
	    public Col(string idd, string l ) {  this ( idd, l, COL_STRING ); }
	    public Col(string idd, string l, string ct ) {id = idd; label = l; type =  ct;}
 	}



 	/*
		Row structure:
		Each row is an array of cells. The number of cells should match the number of columns.
		A cell can be an object as described below, or a null,
		so if you have a row with null values, you can just skip them in the array.
		For example, if there are 3 columns, and in  a certain row the first two
		cells are nulls, you can specify: [ , , {v: '3rd cell value'}]
	*/
 	public class Row {

    	public List<cell> c;

    	/*
    		Constructors
    	*/
    	public Row() { this ( new List<cell>() ) ; }

    	public Row( list<cell> c) { this.c = c; }

    	/*
    		@param Cell
    	*/
    	public void addCell( Cell aCell  ) { this.c.add( aCell ); }

 	}


	/*Cell structure: Each cell is an object with two optional values:

		v: Value. Optional. If does not exists, or contains null, then the cell is assumed to be a null cell. Otherwise, the value type should match the column type, in the following mapping:

  			boolean: A javascript boolean value: true, false
  			number: A javascript number: 2, -3.2
  			string: A javascript string: 'some value'
  			date: A javascript Date: new Date(2008, 1, 28, 0, 31, 26)
  			datetime: A javascript Date: new Date(2008, 1, 28, 0, 31, 26)
  			timeofday: A javascript array of 3 or 4 numbers: [hours, minutes, seconds] or
  				[hours, minutes, seconds, milliseconds]
		f: Formatted value. String. Optional. The formatted value of this cell. Used by some visualizations (like table, and more). If the formatted value is not defined (or it is null), and is asked for, there is a default formatting that depends on the column type.

 */
	public class Cell {

    	public Object v;              // value
    	public String f;		      // Formatted value

		public cell ( Object value ){ this( value, null ); }

		public cell ( Object value , String formatedVal ){ v = value ; f = formatedVal ;}
	}

	 /*
 		@param Row
 	*/
	public void addRow( Row r ) { this.rows.add( r ) ; }


 	/*
 		@return String
 	*/
 	public string toJSONString() { return JSON.serialize( this ); }

 /***************************TEST METHODS**************************************/

 	private static testmethod void testAddRow() {

	    GoogleViz gv = new GoogleViz();

		Test.startTest();
			gv.addRow( new Row() );
	    Test.stopTest();

		System.assertEquals( 1,  gv.rows.size() );

	}

 	private static testmethod void testToJSONString() {

	    GoogleViz gv = new GoogleViz();

	    gv.cols = new list<Col> { new GoogleViz.Col('A','New A', COL_STRING ),
	         					  new GoogleViz.Col('B','B label', COL_NUMBER ) };

	    Row rr = new Row();

	    GoogleViz.cell ctmp = new GoogleViz.cell('a');

	    rr.addCell ( ctmp );
	    rr.addCell ( new GoogleViz.cell( 3, '3ish' ) ); // {v: 3.0, f: '3'}

	    rr.addCell ( new GoogleViz.cell( Date.newInstance(2008,3,30), '4/30/08 12:31 AM' ) );

	    gv.addRow( rr );

		String actualJson;

		Test.startTest();
			actualJson = gv.toJSONString() ;
		Test.stopTest();

		System.assertNotEquals(null , actualJson , ' This should be a valid JSON String ' );

	}

 	private static testmethod void testColClass() {

 		final String ID    = 'some_id';
 		final String LABEL = 'some_label';
 		final String CTYPE = 'some_type';

    	Test.startTest();

    		Col  noParamColumn =  new Col();

    		Col  oneParamColumn =  new Col( ID );

    		Col  twoParamColumn =  new Col( ID, LABEL );

    		Col  threeParamColumn =  new Col( ID, LABEL, CTYPE );

   		Test.stopTest();

   		System.assertEquals( null       , noParamColumn.id );
   		System.assertEquals( null       , noParamColumn.label );
   		System.assertEquals( COL_STRING , noParamColumn.type );

   		System.assertEquals( ID         , oneParamColumn.id );
   		System.assertEquals( null       , oneParamColumn.label );
   		System.assertEquals( COL_STRING , oneParamColumn.type );

   		System.assertEquals( ID         , twoParamColumn.id );
   		System.assertEquals( LABEL      , twoParamColumn.label );
   		System.assertEquals( COL_STRING , twoParamColumn.type );

   		System.assertEquals( ID    , threeParamColumn.id );
   		System.assertEquals( LABEL , threeParamColumn.label );
   		System.assertEquals( CTYPE , threeParamColumn.type );

	}

	private static testmethod void testRowClass() {

 		final List<Cell> someCells = new List<Cell> { new Cell( null ) };

    	Test.startTest();

    		Row  noParamRow =  new Row();

    		Row  oneParamRow =  new Row( someCells );

   		Test.stopTest();

   		System.assertNotEquals( null , noParamRow.c, 'The constructor should initialize the cell list ' );

   		System.assertEquals( 1,  oneParamRow.c.size() );

	}

	private static testmethod void testRowClass_addCell() {

    	Row  aRow =  new Row();

    	Test.startTest();

    		aRow.addCell( new Cell( null ) );

   		Test.stopTest();

   		System.assertEquals( 1,  aRow.c.size() , 'The cell should be added');

	}

 	private static testmethod void testCellClass() {

 		final Object VALUE           = Date.today();
 		final String FOMARTTED_VALUE = 'some_formatted_string';

    	Test.startTest();

    		Cell  oneParamCell =  new Cell( VALUE );

    		Cell  twoParamCell =  new Cell( VALUE, FOMARTTED_VALUE );

   		Test.stopTest();

   		System.assertEquals( VALUE , oneParamCell.v );
   		System.assertEquals( null  , oneParamCell.f );

   		System.assertEquals( VALUE            , twoParamCell.v );
   		System.assertEquals( FOMARTTED_VALUE  , twoParamCell.f );

	}
}