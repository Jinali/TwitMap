package atri.cloud;

import java.io.IOException;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import twitter4j.Query;
import twitter4j.QueryResult;
import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.EntityNotFoundException;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;
//import java.util.logging.*;


@SuppressWarnings("serial")
public class TwittMapServlet extends HttpServlet {

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		Twitter twitter = new TwitterFactory().getInstance();
		String keywords[] = {"happy", "birthday", "great", "love", "world", "good", "friend"};
		int counter = 0;
		try {
			for (String key : keywords) {
				Query query = new Query(key);
				QueryResult result;

				do {
					result = twitter.search(query);
					List<Status> tweets = result.getTweets();
					for (Status tweet : tweets) {
						if(tweet.getGeoLocation()!=null)
						{							
							Key allKey = KeyFactory.createKey("allkind", "all");
							Key keywordKey = KeyFactory.createKey(key+"kind", key);
							DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
							
							Entity allEnt = new Entity("twitt", allKey);
							Entity keywordEnt = new Entity("twitt", keywordKey);
							
							allEnt = loadTwittEntity(allEnt, tweet);
							datastore.put(allEnt);

							keywordEnt = loadTwittEntity(keywordEnt, tweet);
							datastore.put(keywordEnt);

							counter++;
						}
					}
				} while ((query = result.nextQuery()) != null);
			}
			System.out.println(counter+" geotagged Twitts loaded!");
		} catch (TwitterException te) {
			te.printStackTrace();
			System.err.println("Failed to search tweets: " + te.getMessage());
		}

		resp.setContentType("text/plain");
		resp.getWriter().println(counter+" geotagged Twitts loaded!");
	}

	public Entity loadTwittEntity(Entity twitt, Status status){
		twitt.setProperty("username", status.getUser().getScreenName());
		twitt.setProperty("tweetId",status.getId());
		twitt.setProperty("content",status.getText());
		twitt.setProperty("latitude", status.getGeoLocation().getLatitude());
		twitt.setProperty("longitude", status.getGeoLocation().getLongitude());
		twitt.setProperty("date", status.getCreatedAt());
		twitt.setProperty("day", getDayOfWeek());
		return twitt;
	}


	public static String getDayOfWeek()
	{
		Calendar c = Calendar.getInstance();
		c.setTime(c.getTime());
		String dayOfWeek = "";
		int d = c.get(Calendar.DAY_OF_WEEK);
		if(d==1)
			dayOfWeek = "sunday";
		else if(d==2)
			dayOfWeek = "monday";
		else if(d==3)
			dayOfWeek = "tuesday";
		else if(d==4)
			dayOfWeek = "wednesday";
		else if(d==5)
			dayOfWeek = "thursday";
		else if(d==6)
			dayOfWeek = "friday";
		else if(d==7)
			dayOfWeek = "saturday";

		return dayOfWeek;
	}
}

