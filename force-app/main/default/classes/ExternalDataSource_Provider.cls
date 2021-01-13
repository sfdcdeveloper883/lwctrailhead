global class ExternalDataSource_Provider extends DataSource.Provider{
     
    /**
     * Define Supported Authentication capability
     **/
    override global List<DataSource.AuthenticationCapability> getAuthenticationCapabilities() {
        List<DataSource.AuthenticationCapability> capabilities =  new List<DataSource.AuthenticationCapability>();
        capabilities.add(DataSource.AuthenticationCapability.ANONYMOUS);
    	return capabilities;
	}
    
    /**
     * Other capabilities supported by Custom Adapters 
     **/
    override global List<DataSource.Capability> getCapabilities()
    {
        List<DataSource.Capability> capabilities = new
            List<DataSource.Capability>();
        capabilities.add(DataSource.Capability.ROW_QUERY);
        capabilities.add(DataSource.Capability.SEARCH); 
        //Below Capabilities are not supported in this example
        //capabilities.add(DataSource.Capability.ROW_CREATE);
        //capabilities.add(DataSource.Capability.ROW_UPDATE);
        //capabilities.add(DataSource.Capability.ROW_DELETE);
        return capabilities;
    }
    
    /**
     *  obtain the external system’s schema and handle 
     *  the queries and searches of the external data
     **/
    override global DataSource.Connection getConnection(DataSource.ConnectionParams connectionParams) {   
        return new ExternalDS_Healthcare(connectionParams);
    } 
}