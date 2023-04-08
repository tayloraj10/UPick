from firebase import Firebase
import json
import requests
import pprint
from bs4 import BeautifulSoup
import pandas as pd
from datetime import datetime
import firebase_admin
from firebase_admin import credentials, firestore


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


cred = credentials.Certificate(
    r"C:\Users\taylo\Downloads\upick-775b7-firebase-adminsdk-99rxv-8393fddd54.json")
firebase_admin.initialize_app(cred)
db = firestore.client()


# post_to_firestore(prepare_movies(100))


def prepare_movies(num_pages=25):
    popular = fetch_url_data(popular_url, num_pages)
    popular_titles = unique_titles(popular)
    top_rated = fetch_url_data(top_rated_url, num_pages)
    top_rated_titles = unique_titles(top_rated)
    master_list = unique_movies(popular + top_rated)
    return fetch_movie_data(master_list, popular_titles, top_rated_titles)


def post_to_firestore(movie_data):
    wipe_movies_db()
    for m in movie_data:
        db.collection(u'movies').add(m)
    get_counts()


def wipe_movies_db():
    docs = db.collection(u'movies').stream()

    for doc in docs:
        db.collection(u'movies').document(doc.id).delete()


def get_counts():
    total_count = 0
    popular_count = 0
    top_rated_count = 0
    both_count = 0
    streaming_map = {}
    genre_map = {}
    movie_not_found_ten = []
    for doc in db.collection(u'movies').stream():
        data = doc.to_dict()
        total_count += 1
        if data['popular']:
            popular_count += 1
        if data['top_rated']:
            top_rated_count += 1
        if data['popular'] and data['top_rated']:
            both_count += 1
            # print(data['Title'])
        for s in data['streaming_options']:
            if s in streaming_map.keys():
                streaming_map[s] = streaming_map[s] + 1
            else:
                streaming_map[s] = 1
        for g in data['Genres'].split(','):
            g = g.strip()
            if g in genre_map.keys():
                genre_map[g] = genre_map[g] + 1
            else:
                genre_map[g] = 1
        if 'Movie Not Found' in data['streaming_options'] and len(movie_not_found_ten) < 10:
            movie_not_found_ten.append(
                data['Title'] + "-(" + data['Year'] + ")")
    print('Total Count: {}'.format(total_count))
    print('Popular Count: {}'.format(popular_count))
    print('Top Rated Count: {}'.format(top_rated_count))
    print('Both Count: {}'.format(both_count))
    print('\n10 Movies that could not be scraped:')
    pprint.pprint(movie_not_found_ten)
    print('\nStreaming Service Breakdown')
    pprint.pprint(sorted(streaming_map.items(),
                  key=lambda x: x[1], reverse=True))
    print('\nGenre Breakdown')
    pprint.pprint(sorted(genre_map.items(), key=lambda x: x[1], reverse=True))


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

            streaming_services = find_streaming_services(
                json_data['Title'], json_data['Year'])

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
                'streaming_options': list(set().union(*(d.keys() for d in streaming_services))),
                'popular': popular,
                'top_rated': top_rated,
                'date_fetched': datetime.now()
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
    # print(final_name[:-1])
    return final_name[:-1]


def find_streaming_services(movie_name, year):
    streaming_services = []
    try:
        r = requests.get(streaming_url_stub + convert_movie_name(movie_name))
        if r.status_code == 404:
            r = requests.get(streaming_url_stub +
                             convert_movie_name(movie_name))
            print('second try')
            if r.status_code == 404:
                r = requests.get(
                    streaming_url_stub + convert_movie_name(movie_name + ' ' + str(year)))
                print(convert_movie_name(movie_name + ' ' + str(year)))
                print('add year')
                if r.status_code == 404:
                    r = requests.get(streaming_url_stub +
                                     convert_movie_name('the ' + movie_name))
                    print(convert_movie_name('the ' + movie_name))
                    print('add the to beginning')
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
        print(e)
        return [{'Movie Not Found': ''}]
