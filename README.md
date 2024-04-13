<h1 align="center">
  <img src="icons/moovc.png" alt="Moo VC" width="256" height="256"/><br>
  MooVC
</h1>

<p align="center"><em>(pronounced "Movie see")</em></p>

<h4 align="center">A demonstration of the MVC architecture as a frontend to <a href="https://www.themoviedb.org/">the Movie Database</a></h4>

### Notable Features

- Session ID and Account identifier are both stored in the Keychain securely.
- Use of the [Multipeer Connectivity
  framework](https://developer.apple.com/documentation/multipeerconnectivity)
  for movie sharing between nearby devices.
- A single controller (`MovieListingController`) is in charge of every
  collection view used in the app.

## Assignment

This application was developed as part of a university course on the
Introduction to Mobile Development on the iOS Platform. The goal was to develop
an iOS application that could show users information on different movies,
fetched from the TheMovieDB API, allowing users to search, and mark movies as
favorites, as well as showcasing the most popular titles on common genres.

The only requirement on technical decisions was having to follow the MVC
architecture strictly, which presented the need for some indirection when
implementing the Discover screen but ended up making new flows such as Search
and Favorites simpler to get done.

As Extra Credit, MooVC also allows users to share films with nearby friends and
family, using [Multipeer
Connectivity](https://developer.apple.com/documentation/multipeerconnectivity)
through the (now unsupported) [MultiPeer
pod](https://github.com/dingwilson/MultiPeer).

## Features

### Log In Flow

MooVC allows users with a TMDB account to log in but does not currently support
a sign-up flow. The `LoginViewController` is responsible for the flow, in
collaboration with the `SessionManager` singleton in order to call the "Create
Request Token", "Create Session (with login)" and "Create Session" endpoints.

### Discovery, Search and Favorites

The main tab of MooVC is the Discovery screen. Here users can see the most
popular movies in each genre, with the option to load more films on a particular
genre or go into a particular movie's details. This is managed by the
DiscoverViewController.

Search offers a similar experience, but instead of grouping movies under genre,
it offers a single collection that the user can search through, getting popular
movies that fit the query from the API. The `SearchViewController` controls this
tab.

Finally, as users mark films as favorites, stored by the TMDB API, they can also
be seen on the "favorite movies" tab, controlled by the
`FavouritesViewController` class.

### Peer-to-peer sharing

By hopping onto the final tab, users can enable "peer to peer" sharing, to build
a list of movies together with close-by friends or family. While the screen is
controlled by the `PeerViewController` class the underlying logic of talking to
other devices through the Multipeer connectivity framework is abstracted away by
the MovieSharing class, to hide the details of peer finding and encoding.
