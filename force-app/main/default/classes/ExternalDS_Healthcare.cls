global class ExternalDS_Healthcare extends DataSource.Connection {
    
    private String EXTERNAL_SRC_URL = 'https://www.healthcare.gov/api/blog.json';
    private final String EXTERNAL_SRC_BASEURL = 'https://www.healthcare.gov';
    private final String  COL_HEADER_TITLE = 'title';
    private final String COL_HEADER_SEO_KEYWORDS = 'seo-keywords';
    private final String COL_HEADER_EXCERPT = 'excerpt';
    private final String COL_HEADER_CONTENT = 'content';
    private final String COL_HEADER_LANGUAGE = 'lang';
    private final String COL_HEADER_BLOGLINK = 'url'; 
    private final String COL_HEADER_DISPLAYURL = 'DisplayUrl';
    private final String COL_HEADER_EXTERNAL_ID = 'ExternalId'; 
    
    private DataSource.ConnectionParams conParam ;
        
    //Constructor
    global ExternalDS_Healthcare(DataSource.ConnectionParams connectionParams){    
        conParam = connectionParams; 
    }    
    
    /**
     * Below method is invoked if global search is used or SOSL issued
     * */
    override global List<DataSource.TableResult> search(DataSource.SearchContext context) {
        List<DataSource.TableResult> results = new List<DataSource.TableResult>();
        for (DataSource.TableSelection tableSelection : context.tableSelections) {
            results.add(DataSource.TableResult.get(tableSelection, getRows( )));
        }
        return results;
    }
    
    /**
     * Abstract Methos sync() must be implemented as part of DataSource.Connection class
     * This methos would define Schema of External Object
     * 
     * NOTE : ExternalId and DisplayURL are manadatory column
     * */
    override global List<DataSource.Table> sync() {
        List<DataSource.Table> tables = new List<DataSource.Table>();
        
        List<DataSource.Column> columns = new List<DataSource.Column>();
        columns.add(DataSource.Column.text(COL_HEADER_TITLE, 1000));
        columns.add(DataSource.Column.text(COL_HEADER_SEO_KEYWORDS, 500));
        columns.add(DataSource.Column.text(COL_HEADER_EXCERPT,6000));
        columns.add(DataSource.Column.text(COL_HEADER_CONTENT,60000));
        columns.add(DataSource.Column.text(COL_HEADER_LANGUAGE,100));
        columns.add(DataSource.Column.text(COL_HEADER_EXTERNAL_ID,100)); 
        
        columns.add(DataSource.Column.url(COL_HEADER_DISPLAYURL));
        
        tables.add(DataSource.Table.get('HealthcareBlog', COL_HEADER_EXTERNAL_ID, columns)); 
        return tables;
    }
    
    /**
     * This method is called everytime when SOQL is issued against external Object
     * or while using list view or viewing detail page.
     * 
     * Note : Ideally searching should be done at server side however for sake of 
     * simplicity, we would be using "DataSource.QueryUtils" class provided by
     * Salesforce. In this case, filtering and sorting would be done in Salesforce
     * once response returned by external REST API
     * */
     override global DataSource.TableResult query( DataSource.QueryContext context) {
        if (context.tableSelection.columnsSelected.size() == 1 && context.tableSelection.columnsSelected.get(0).aggregation == DataSource.QueryAggregation.COUNT) {
                List<Map<String,Object>> rows = getRows( );
                List<Map<String,Object>> response = DataSource.QueryUtils.filter(context, getRows( ));
                List<Map<String, Object>> countResponse = new List<Map<String, Object>>();
                Map<String, Object> countRow = new Map<String, Object>();
                countRow.put( context.tableSelection.columnsSelected.get(0).columnName, response.size());
                countResponse.add(countRow);
                return DataSource.TableResult.get(context, countResponse);
        } else {
            List<Map<String,Object>> filteredRows =  DataSource.QueryUtils.filter(context, getRows( ));
            List<Map<String,Object>> sortedRows = DataSource.QueryUtils.sort(context, filteredRows);
            List<Map<String,Object>> limitedRows = DataSource.QueryUtils.applyLimitAndOffset(context, sortedRows);
            return DataSource.TableResult.get(context, limitedRows);
        }
    }
    
    /**
     * Make REST callout to external system and parse the result in required format
     * */
    private List<Map<String,Object>> getRows( ){
        
        List<Map<String, Object>> lstReturnDataset =  new List<Map<String, Object>>();
        
        HttpRequest req = new HttpRequest();
        req.setEndPoint(EXTERNAL_SRC_URL);
        req.setMethod('GET');
        HttpResponse res = new Http().send(req);
        
        Map<String, Object> json_resp = ( Map<String, Object>)JSON.deserializeUntyped(res.getBody());
        
        List<Object> lstBlog = (List<Object>)json_resp.get('blog');
        
        for(Object blog : lstBlog){
            Map<String, Object> blogMap = (Map<String, Object>) blog;
            Map<String, Object> curRow = new Map<String, Object>();
            curRow.put(COL_HEADER_TITLE,blogMap.get(COL_HEADER_TITLE));
            curRow.put(COL_HEADER_SEO_KEYWORDS,blogMap.get(COL_HEADER_SEO_KEYWORDS));
            curRow.put(COL_HEADER_EXCERPT,blogMap.get(COL_HEADER_EXCERPT));
            curRow.put(COL_HEADER_CONTENT,blogMap.get(COL_HEADER_CONTENT));
            curRow.put(COL_HEADER_LANGUAGE,blogMap.get(COL_HEADER_LANGUAGE));
            curRow.put(COL_HEADER_DISPLAYURL,EXTERNAL_SRC_BASEURL+blogMap.get(COL_HEADER_BLOGLINK)); 
            curRow.put(COL_HEADER_EXTERNAL_ID, String.valueOf(blogMap.get(COL_HEADER_BLOGLINK)).replaceAll('/','_')); 
            
            lstReturnDataset.add(curRow);
        }
        
        return lstReturnDataset;
    } 
}