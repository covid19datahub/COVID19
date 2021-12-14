function downloadTable(el, slug) {
	var html = '';
	var id = el.value;
	var name = $(el).text();
	if(id){
		var url = "https://storage.covid19datahub.io/"+slug+"/"+id+".csv";
		html = 
		"<table class=\"table\">" +
			"<colgroup>" +
				"<col width='39%'>" +
				"<col width='28%'>" +
				"<col width='18%'>" +
				"<col width='12%'>" +
			"</colgroup>" +
			"<thead>" +
				"<tr class=\"header\">" +
					"<th>URL</th>" +
					"<th>Description</th>" +
					"<th>Format</th>" +
					"<th>Downloads</th>" +
				"</tr>" +
			"</thead>" +
			"<tbody>" +
				"<tr>" +
					"<td><a href='"+url+".zip'>"+url+".zip</a></td>" +
					"<td>"+name+"</td>" +
					"<td><a href='"+url+"'>CSV</a> – <a href='"+url+".zip'>ZIP</a> – <a href='"+url+".gz'>GZIP</a></td>" +
					"<td><img src=\"https://storage.covid19datahub.io/downloads/"+slug+"/"+id+".svg\" onerror=\"this.src='https://img.shields.io/badge/downloads-0-blue'\"/></td>" +
				"</tr>" +
			"</tbody>" +
		"</table>";
	}
	document.getElementById("download-"+slug).innerHTML = html;
}

$(function () {
	if ( $.isFunction($.fn.selectize) ) {
		$(".selectize").selectize({
			sortField: "text",
		});
	}
});
