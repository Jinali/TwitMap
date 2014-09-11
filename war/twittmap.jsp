<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.logging.Level"%>
<%@ page import="com.google.appengine.api.datastore.DatastoreService"%>
<%@ page
	import="com.google.appengine.api.datastore.DatastoreServiceFactory"%>
<%@ page import="com.google.appengine.api.datastore.Entity"%>
<%@ page import="com.google.appengine.api.datastore.FetchOptions"%>
<%@ page import="com.google.appengine.api.datastore.Key"%>
<%@ page import="com.google.appengine.api.datastore.KeyFactory"%>
<%@ page import="com.google.appengine.api.datastore.Query"%>
<%@ page import="com.google.appengine.api.datastore.Query.Filter"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterPredicate"%>
<%@ page import="com.google.appengine.api.datastore.Query.FilterOperator"%>
<%@ page import="com.google.appengine.api.memcache.ErrorHandlers"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheService"%>
<%@ page import="com.google.appengine.api.memcache.MemcacheServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
<script
	src="http://maps.googleapis.com/maps/api/js?key=AIzaSyAq1qbnV6PGUYiTDuhDpisqsEmeDQYYHkk&sensor=false&v=3.exp&sensor=false&libraries=visualization">
</script>

<script>
var mapCenter=new google.maps.LatLng(2.8800,23.6560);//Coords for D R Congo
function initialize()
{
	var twittCircle;
	var mapProp = {
	  center:mapCenter,
	  zoom:2,
	  mapTypeId:google.maps.MapTypeId.ROADMAP
	  };

	var map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

	<%
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		//MemcacheService twittCache = MemcacheServiceFactory.getMemcacheService(); 
		//twittCache.setErrorHandler(ErrorHandlers.getConsistentLogAndContinue(Level.INFO));
		List<Entity> twittsList = null;
		Query query = null;
		String queryKey = "allkind";
		String filter = request.getParameter("filter");
		String tweetday = request.getParameter("tweetday");
		if(filter!=null && filter!="all"){
			queryKey = filter;		
		}
		
		//twittsList = (List<Entity>)twittCache.get(queryKey);
		if(twittsList==null){
			if(tweetday!=null){
			    Key twittKey = KeyFactory.createKey("allkind", "all");
			    Filter dayFilter = new FilterPredicate("day",FilterOperator.EQUAL, tweetday);
		    	query = new Query("twitt", twittKey).setFilter(dayFilter);
	%>
	<%
			} else {
			    Key twittKey = KeyFactory.createKey(queryKey+"kind", queryKey);
		    	query = new Query("twitt", twittKey);
			}
		    twittsList = datastore.prepare(query).asList(FetchOptions.Builder.withLimit(5000));
		    //twittCache.put(queryKey, twittsList);
		}
		%>
	    // Run an ancestor query to ensure we see the most up-to-date
	    // view of the Greetings belonging to the selected Guestbook.
	      
		    var latLngs = [
        	<%for(Entity twitt:twittsList){%>	
		      new google.maps.LatLng(<%=twitt.getProperty("latitude")%>, <%=twitt.getProperty("longitude")%>),
		  	<%}%>
		  	  new google.maps.LatLng(-84.055894,144.862976)
		  	  ];

	  var pointArray = new google.maps.MVCArray(latLngs);
	  var heatmap = new google.maps.visualization.HeatmapLayer({
	    data: pointArray
	  });
	  heatmap.setMap(map);
}
	google.maps.event.addDomListener(window, 'load', initialize);
</script>

</head>

<body>
	<select onchange="document.location.href='/twittmap.jsp?filter='+this.value;" >
		<option value="none" selected>None</option>
		<option value="all" >All</option>
		<option value="happy">happy</option>
		<option value="birthday">birthday</option>
		<option value="love">love</option>
		<option value="world">world</option>
		<option value="friend">friend</option>
		<option value="good">good</option>
		<option value="great">great</option>
	</select>
	
	<table>
		<tr>
			<td><a href="/twittmap.jsp?tweetday=sunday">Sunday</a></td>
			<td><a href="/twittmap.jsp?tweetday=monday">Monday</a></td>
			<td><a href="/twittmap.jsp?tweetday=tuesday">Tuesday</a></td>
			<td><a href="/twittmap.jsp?tweetday=wednesday">Wednesday</a></td>
			<td><a href="/twittmap.jsp?tweetday=thursday">Thursday</a></td>
			<td><a href="/twittmap.jsp?tweetday=friday">Friday</a></td>
			<td><a href="/twittmap.jsp?tweetday=saturday">Saturday</a></td>
		</tr>
	</table>
	
	<div id="googleMap" style="width: 1200px; height: 500px;"></div>
	
	<table>
		<tr>
			<th>TweetID</th>
			<th>Content</th>
			<th>Username</th>
			<th>Day</th>
			<th>Latitude</th>
			<th>Longitude</th>
		</tr>
		<%
		    for(Entity twitt:twittsList){%>
			<tr>
				<td><%=twitt.getProperty("tweetId")%></td>
				<td><%=twitt.getProperty("content")%></td>
				<td><%=twitt.getProperty("username")%></td>
				<td><%=twitt.getProperty("day")%></td>
				<td><%=twitt.getProperty("latitude")%></td>
				<td><%=twitt.getProperty("longitude")%></td>
			</tr>
		<% } %>
	</table>
	
</body>
</html>