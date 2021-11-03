function downloadCountry(iso) {
	var html = '';
	if(iso){
		var url = "https://storage.covid19datahub.io/country/"+iso+".csv";
		html = "Download link: <a href='"+url+"'>"+url+"</a><br/><br/>";
	}
	document.getElementById("download-country").innerHTML = html;
}

function downloadPlace(key) {
	var html = '';
	if(key){
		var url = "https://storage.covid19datahub.io/place/"+key+".csv";
		html = "Download link: <a href='"+url+"'>"+url+"</a><br/><br/>";
	}
	document.getElementById("download-place").innerHTML = html;
}

$(function () {
  $(".selectize").selectize({
	  sortField: "text",
  });
});
