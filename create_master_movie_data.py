from os import name
from firebase import Firebase
import prepare_movie_data
import pprint

# constants
movie_db_api_key = "4916feb4e9a67da7d30cb816f69cb88b"
omdb_url_stub = "http://www.omdbapi.com/?apikey=a80dc353&type=movie&plot=short&t="
imdbURL = "https://www.imdb.com/title/"
posterUrl = "https://image.tmdb.org/t/p/w500"
genre_url = "https://api.themoviedb.org/3/genre/movie/list?api_key=4916feb4e9a67da7d30cb816f69cb88b&language=en-US"

popular_url = "https://api.themoviedb.org/3/movie/popular?api_key={}&language=en-US&page=".format(
    movie_db_api_key)
top_rated_url = "https://api.themoviedb.org/3/movie/top_rated?api_key={}&language=en-US&page=".format(
    movie_db_api_key)


num_pages = 50

popular = prepare_movie_data.fetch_url_data(popular_url, num_pages)
top_rated = prepare_movie_data.fetch_url_data(top_rated_url, num_pages)


# pprint.pprint(prepare_movie_data.fetch_movie_data(popular[:2]))


# save_data(prepare_movie_data.fetch_movie_data(popular[:2]))

def unique_titles(data):
    unique_titles = set()
    for movie in data:
        if movie['title'] not in unique_titles:
            unique_titles.add(movie['title'])
        # else:
        #     print(movie['title'])
    return unique_titles


def unique_movies(data):
    unique_titles = set()
    unique_movies = []
    for movie in data:
        if movie['Title'] not in unique_titles:
            unique_titles.add(movie['Title'])
            unique_movies.append(movie)
    return unique_movies


def prepare_new_data():
    data = prepare_movie_data.fetch_movie_data(
        popular) + prepare_movie_data.fetch_movie_data(top_rated)

    movies = unique_movies(data)

    popular_titles = unique_titles(popular)
    top_rated_titles = unique_titles(top_rated)
    for movie in movies:
        movie['popular'] = False
        movie['top_rated'] = False
        if movie['Title'] in popular_titles:
            movie['popular'] = True
        if movie['Title'] in top_rated_titles:
            movie['top_rated'] = True

    return movies


def save_data(data):
    config = {
        'apiKey': "AIzaSyAEespYo4MImAl0izGX4crFWIljLUhQW5Y",
        'authDomain': "upick-775b7.firebaseapp.com",
        'databaseURL': "https://upick-movie-data.firebaseio.com",
        'projectId': "upick-775b7",
        'storageBucket': "upick-775b7.appspot.com"
    }
    firebase = Firebase(config)
    db = firebase.database()
    db.child('').set(data)


def get_firebase_data():
    config = {
        'apiKey': "AIzaSyAEespYo4MImAl0izGX4crFWIljLUhQW5Y",
        'authDomain': "upick-775b7.firebaseapp.com",
        'databaseURL': "https://upick-movie-data.firebaseio.com",
        'projectId': "upick-775b7",
        'storageBucket': "upick-775b7.appspot.com"
    }
    firebase = Firebase(config)
    db = firebase.database()
    data = db.get().val()
    return data


if __name__ == "__main__":
    data = prepare_new_data()
    save_data(data)
