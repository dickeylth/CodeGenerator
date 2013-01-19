$(document).ready(function(){
	var init_json = $('#domain_json').val(),
	    columtypes = ['String', 'Int', 'Float', 'Date', 'Boolean'];
	    
	if(init_json == ''){
	    init_json = [{
	        tablename: '用户',
	        columns: [{
	            name: 'user_id',
	            type: 'Int',
	            empty: false,
	            pk: true,
	            ref_table: null,
	            ref_table_col: null,
	            ref_type: null
	        },{
	            name: 'username',
                type: 'String',
                empty: false,
                pk: false,
                ref_table: null,
                ref_table_col: null,
                ref_type: null
	        },{
                name: 'password',
                type: 'String',
                empty: false,
                pk: false,
                ref_table: null,
                ref_table_col: null,
                ref_type: null
            },{
                name: 'enabled',
                type: 'Boolean',
                empty: false,
                pk: false,
                ref_table: null,
                ref_table_col: null,
                ref_type: null
            }
	        ],
	        columtypes: columtypes
	    }];

	}
	
});