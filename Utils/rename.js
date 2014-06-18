/*
1 install nodejs and cheerio( for jquery link css selector search in nodejs)
npm install cheerio
npm install cheerio -g
2 cd Utils; node rename.js; 
3  sd.zip and hd.zip is all has renmaed srt file zipped
4  download_links.txt has all wwdc 2014 hd video download link
*/

var http =  require('https');
var url  = "https://developer.apple.com/videos/wwdc/2014/";

/*
http.get(url, function(res) {
    var source = "";
    //通过 get 请求获取网页代码 source
    res.on('data', function(data) {
        source += data;
    });
    //获取到数据 source，我们可以对数据进行操作了!
    res.on('end', function() {
        console.log(source);
        //这将输出很多的 html 代码
		
		
    });
}).on('error', function() {
    console.log("获取数据出现错误");
});
*/


var fs 			  = require('fs');
var html_content  = fs.readFileSync("wwdc2014_src.html");
var cheerio  	  = require('cheerio'),
$ 			 	  = cheerio.load(html_content);
var sessions 	  = $('li.session');
var res 		  = [];

function model_session() {
  var tmp = {
     title:"",
     hd : "",
     sd : "",
     pdf: "",
     track:"",
     platform:"",
     id:"",
	 index:"",
	 get_file_srt_name:function( url ){
	   var last_index = url.lastIndexOf("/");
	   var result     = url.substring(last_index+1);
	   result         = result.replace("?dl=1","");
	   result         = result.replace(".mov",".srt");
	   
	   //console.log(last_index);
	   return result;
	 }
  };
  return tmp;
}
for (var i = 0; i < sessions.length; i++) {
   var session    = $(sessions[i]);
   var row        = new model_session;
   row["id"]      = session.attr("id");
   row["index"]	  = row["id"].substring(0,3);
   row["title"]   = session.find("li.title").html();
   row["track"]   = session.find("li.track").html();
   row["platform"] = session.find("li.platform").html();

   var download_links   			= session.find("p.download > a");
   for (var j = 0; j < download_links.length; j++) {
       var d      					= $(download_links[j]);
       var type_str 			   	= d.html();
       row[type_str.toLowerCase()] 	= d.attr("href");
   }
   
   res.push(row);
}

res.forEach(function(row){
	var link = row.hd;
	console.log(link);
	if(link){
		var simple_file_name = row.get_file_srt_name( link );
		var old_path		 = "../" + row.index + ".srt";
		var new_path		 = "../" + simple_file_name;
		
		if(fs.existsSync(old_path))
		{
			//console.log(simple_file_name,old_path,new_path);
			fs.renameSync(old_path, new_path);
		}
		
	}
});


		
