from firebase import Firebase
import json
import requests
import pprint
from bs4 import BeautifulSoup
import pandas as pd

data_fields = [
    'Cast',
    'Director',
    'Genres',
    'Plot',
    'Poster',
    'Rated',
    'Rating',
    'Runtime',
    'Streaming',
    'Title',
    'Year',
    'imdbID',
    'popular',
    'top_rated',
]
# constants
movie_db_api_key = "4916feb4e9a67da7d30cb816f69cb88b"
# omdb_url_stub = "http://www.omdbapi.com/?apikey=a80dc353&type=movie&plot=short&t="
omdb_url_stub = "http://www.omdbapi.com/?apikey=4500cc76&type=movie&plot=short&t="
imdbURL = "https://www.imdb.com/title/"
posterUrl = "https://image.tmdb.org/t/p/w500"
genre_url = "https://api.themoviedb.org/3/genre/movie/list?api_key=4916feb4e9a67da7d30cb816f69cb88b&language=en-US"
streaming_url_stub = "https://www.justwatch.com/us/movie/"


popular_url = "https://api.themoviedb.org/3/movie/popular?api_key={}&language=en-US&page=".format(
    movie_db_api_key)
top_rated_url = "https://api.themoviedb.org/3/movie/top_rated?api_key={}&language=en-US&page=".format(
    movie_db_api_key)


def prepare_movies():
    popular = fetch_url_data(popular_url, 1)
    popular_titles = unique_titles(popular)
    top_rated = fetch_url_data(top_rated_url, 1)
    top_rated_titles = unique_titles(top_rated)
    master_list = unique_movies(popular + top_rated)
    return fetch_movie_data(master_list, popular_titles, top_rated_titles)


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


def get_existing_firebase_data():
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


def fetch_url_data(url, num_pages):
    movies = []
    for n in range(1, num_pages + 1):
        new_url = url + str(n)
        json_data = json.loads(requests.get(new_url).content)
        for i in json_data['results']:
            movies.append(i)
    return movies


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
        if movie['title'] not in unique_titles:
            unique_titles.add(movie['title'])
            unique_movies.append(movie)
    return unique_movies


def fetch_movie_data(movies, popular_list, top_rated_list):
    errors = []
    movie_data = []
    for movie in movies:
        if type(movie) == dict:
            url = omdb_url_stub + movie['title']
        elif type(movie) == str:
            url = omdb_url_stub + movie
        try:
            json_data = json.loads(requests.get(url).content)

            if type(movie) == dict:
                poster_data_json = json.loads(requests.get(
                    'https://api.themoviedb.org/3/movie/{}?api_key={}&language=en-US'.format(movie['id'], movie_db_api_key)).content)

                if poster_data_json['title'] == movie['title']:
                    poster_path = posterUrl + poster_data_json['poster_path']
                else:
                    poster_path = json_data['Poster']
            elif type(movie) == str:
                poster_data_json = json.loads(requests.get(
                    'https://api.themoviedb.org/3/search/movie?api_key={}&language=en-US&query={}'.format(movie_db_api_key, movie)).content)

                if poster_data_json['results'][0]['title'] == movie:
                    poster_path = posterUrl + \
                        poster_data_json['results'][0]['poster_path']
                else:
                    poster_path = json_data['Poster']

            streaming_services = find_streaming_services(json_data['Title'])

            popular = json_data['Title'] in popular_list
            top_rated = json_data['Title'] in top_rated_list

            movie_data.append({
                'Poster': poster_path,
                'imdbID': json_data['imdbID'],
                'Title': json_data['Title'],
                'Plot': json_data['Plot'],
                'Cast': json_data['Actors'],
                'Genres': json_data['Genre'],
                'Runtime': json_data['Runtime'],
                'Year': json_data['Year'],
                'Rating': json_data['imdbRating'],
                'Director': json_data['Director'],
                'Rated': json_data['Rated'],
                'Streaming': streaming_services,
                'popular': popular,
                'top_rated': top_rated
            })
        except Exception as e:
            errors.append(movie)
            # print(e)
    print("{} errors occured".format)
    return movie_data


def convert_movie_name(name):
    final_name = ''
    name = name.replace("'", "")
    name = name.replace(':', '')
    name = name.replace('.', '')
    name = name.replace(',', '')
    name = name.replace('?', '')
    for n in name.strip().split():
        final_name += n.lower() + '-'
    return final_name[:-1]


def find_streaming_services(movie_name):
    streaming_services = []
    try:
        r = requests.get(streaming_url_stub + convert_movie_name(movie_name))
        soup = BeautifulSoup(r.content, 'html.parser')
        # stream_row = soup.find(
        #     "div", {"class": "price-comparison__grid__row price-comparison__grid__row--stream"})
        # if 'monetizations' in stream_row.parent['class']:
        #     stream_row = soup.find_all(
        #         "div", {"class": "price-comparison__grid__row price-comparison__grid__row--stream"})[1]
        # monetizations_row = soup.find_all(
        #     "div", {"class": "monetizations"})[-1]
        # stream_row = monetizations_row.find(
        #     "div", {"class": "price-comparison__grid__row price-comparison__grid__row--stream"})
        soup = soup.find('div', {'class': 'price-comparison--block'})
        stream_rows = soup.find_all("div", {
            "class": "price-comparison__grid__row price-comparison__grid__row--stream price-comparison__grid__row--block"})
        stream_row = stream_rows[0]
        if stream_row.find('span', {'class': 'price-comparison__grid__row__title-label'}).text == 'Stream':
            try:
                stream_elements = stream_row.find_all(
                    "div", {"class": "price-comparison__grid__row__element"})

                if stream_elements == []:
                    return [{'No Streaming Available': ''}]

                else:
                    for e in stream_elements:
                        streaming_services.append(
                            {e.find('img')['title']: e.find('a')['href']})
            except Exception as e:
                return [{'No Streaming Available': ''}]

        return streaming_services
    except Exception as e:
        # print('An error occured or no streaming platforms are available')
        return [{'Movie Not Found': ''}]
