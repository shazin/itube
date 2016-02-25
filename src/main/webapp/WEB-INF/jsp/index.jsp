
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<meta name="description" content="Spring Boot - Streaming Response Body">
<meta name="author" content="Shazin Sadakath">

<title>Spring Boot - Streaming Response Body</title>
<style type="text/css">
body {
	background-color: #fdfdfd;
	padding: 0 20px;
	color: #000;
	font: 13px/18px monospace;
	width: 800px;
}

a {
	color: #360;
}

h3 {
	padding-top: 20px;
}
</style>

<!-- Load player theme -->
<link rel="stylesheet"
	href="/resources/themes/maccaco/projekktor.style.css" type="text/css"
	 />

<!-- Bootstrap core CSS -->
<link href="/resources/css/bootstrap.min.css" rel="stylesheet">

<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<link href="/resources/css/ie10-viewport-bug-workaround.css"
	rel="stylesheet">

<!-- Custom styles for this template -->
<link href="/resources/css/jumbotron-narrow.css" rel="stylesheet">

<!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
<!--[if lt IE 9]><script src="../../assets/js/ie8-responsive-file-warning.js"></script><![endif]-->
<script src="/resources/js/ie-emulation-modes-warning.js"></script>

<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>

	<div class="container">
		<div class="header clearfix">
			<nav>
				<ul class="nav nav-pills pull-right">
					<li role="presentation" class="active"><a href="#">Home</a></li>
				</ul>
			</nav>
			<h3 class="text-muted">Streaming Response Body</h3>
		</div>

		<div class="jumbotron">
			<p><div id="player_a" class="projekktor"></div></p>			
		</div>

		<div class="row marketing">
			<div class="col-lg-6">
				<h4>Upload</h4>
				<p><form method="post" enctype="multipart/form-data" action="/video">
				<input type="file" id="file" name="file" accept="video/mp4" /> <input
					type="submit" id="upload" value="Upload" />
			</form></p>				
			</div>

			<div class="col-lg-6">
				<h4>Playlist</h4>
				<p><div id="playlists"></div></p>
			</div>
		</div>

		<footer class="footer">
			<p>&copy; 2015 <a href="www.github.com/shazin">Shazin Sadakath</a>.</p>
		</footer>

	</div>
	<!-- /container -->



	<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
	<script src="/resources/js/ie10-viewport-bug-workaround.js"></script>

	<!-- Load jquery -->
	<script type="text/javascript" src="/resources/jquery-1.9.1.min.js"></script>

	<!-- load projekktor -->
	<script type="text/javascript"
		src="/resources/projekktor-1.3.09.min.js"></script>

	<script type="text/javascript">
    var player;
    $(document).ready(function() {
    	
    	$("#upload").click(function() {
    		var fileValue = $("#file").val();
    		if(!fileValue || fileValue.indexOf('.mp4', fileValue.length - 4) == -1) {
    			alert('Invalid file type or no file selected. Only mp4 files allowed');
    			return false;
    		}
    		return true;
    	});
    	
        player = projekktor('#player_a', {
        poster: '/resources/media/boot.png',
        title: 'This is Spring boot StreamingResponseBody Example',
        playerFlashMP4: '/resources/swf/StrobeMediaPlayback/StrobeMediaPlayback.swf',
        playerFlashMP3: '/resources/swf/StrobeMediaPlayback/StrobeMediaPlayback.swf',
        width: 640,
        height: 385,
        playlist: [
            {            
            0: {src: "/video/bulb.mp4", type: "video/mp4"}            
            }
        ]    
        }, function(player) {
        	player.play();
        } // on ready 
        );
        
        
        $.ajax({
        	  method: "GET",
        	  url: "/video",        	  
        	})
        	  .done(function( videos ) {
        	    var i;        	  
        	    $('#playlists').html('');
        	    for(i in videos) {        	    	
        	    	$('#playlists').append("<a href='#' class='playitem' id='"+videos[i]+"' onclick='playItemOnClick(this);'>"+videos[i]+"</a><br>")        	    	
        	    }       	    
        	  });      
        
        
    });
    
    function playItemOnClick(item) {    	
    	player.setFile('/video/'+item.id, 'video/mp4');
    }
    </script>
</body>
</html>
