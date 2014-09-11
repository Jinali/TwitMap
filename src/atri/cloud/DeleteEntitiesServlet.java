package atri.cloud;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.datastore.DatastoreService;
import com.google.appengine.api.datastore.DatastoreServiceFactory;
import com.google.appengine.api.datastore.Entity;
import com.google.appengine.api.datastore.Key;
import com.google.appengine.api.datastore.KeyFactory;

@SuppressWarnings("serial")
public class DeleteEntitiesServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		Key twittKey = KeyFactory.createKey("Twitt", "TwittKey");
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();

		datastore.delete(twittKey);

		resp.setContentType("text/plain");
		resp.getWriter().println("Deleted all Datastore data!");
	}

	public Entity loadTwittEntity(String[] tokens, Entity twitt){
		twitt.setProperty("username", tokens[0].substring(tokens[0].indexOf(":")+1));
		twitt.setProperty("tweetId",tokens[1].substring(tokens[1].indexOf(":")+1));
		twitt.setProperty("content", tokens[2].substring(tokens[2].indexOf(":")+1));
		twitt.setProperty("latitude", tokens[3].substring(tokens[3].indexOf(":")+1));
		twitt.setProperty("longitude", tokens[4].substring(tokens[4].indexOf(":")+1));
		twitt.setProperty("date", tokens[5].substring(tokens[5].indexOf(":")+1));
		return twitt;
	}
}
