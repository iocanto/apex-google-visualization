public with sharing class ChartsGalleryCtrl {



	public String getSalesAndExpensesJSONData()
	{
		List<String>  years    = new List<String> {'2009', '2010', '2011', '2012'};
		List<Decimal> sales    = new List<Decimal> { 1000 , 1225 , 650 , 1500};
		List<Decimal> expenses = new List<Decimal> { 300  , 360  , 1100, 750 };
		GoogleViz gv = new GoogleViz();
	    gv.cols = new List<GoogleViz.col> {
				new GoogleViz.Col('col1', 'Year', GoogleViz.COL_STRING),
				new GoogleViz.Col('col2', 'Sales', GoogleViz.COL_NUMBER),
				new GoogleViz.Col('col3', 'Expenses', GoogleViz.COL_NUMBER)
	     };

		for ( Integer i = 0; i < years.size() ; ++i  )
		{
			GoogleViz.row aRow = new GoogleViz.row();
			aRow.addCell(new GoogleViz.cell( years[i] ));
			aRow.addCell(new GoogleViz.cell( sales[i]  ));
			aRow.addCell(new GoogleViz.cell( expenses[i] ));
			gv.addRow(aRow);
		}

		return gv.toJSONString();
	}


}