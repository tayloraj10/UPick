import requests
import json
import pprint
import time
from firebase import Firebase
from check_streaming_service_availability import find_streaming_services
import random


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

# genre_json = json.loads(requests.get(genre_url).content)
# pprint.pprint(genre_json)

num_pages = 15

netflix_movies = [
    "13th",
    "20th Century Women",
    "A Ghost Story",
    "A Serious Man",
    "A Shaun the Sheep Movie: Farmageddon",
    "A Single Man",
    "Airplane!",
    "American Factory",
    "American Honey",
    "An Education",
    "Aquarius",
    "Atlantics",
    "Back to the Future",
    "Beasts of No Nation",
    "Being John Malkovich",
    "Blaze",
    "Blue Ruin",
    "Bonnie and Clyde",
    "Burning",
    "CAM",
    "Carol",
    "Casino Royale",
    "Catch Me If You Can",
    "Circus of Books",
    "Crip Camp: A Disability Revolution",
    "Da 5 Bloods",
    "Dallas Buyers Club",
    "Dick Johnson Is Dead",
    "Django Unchained",
    "Dolemite Is My Name",
    "E.T. The Extra-Terrestrial",
    "Enola Holmes",
    "Enter the Dragon",
    "Eternal Sunshine of the Spotless Mind",
    "Frost/Nixon",
    "Fruitvale Station",
    "Fyre",
    "Gerald’s Game",
    "Glory",
    "Good Time",
    "Goodfellas",
    "Her",
    "High Flying Bird",
    "His House",
    "Homecoming: A Film by Beyoncé",
    "Hostiles",
    "Howards End",
    "Hugo",
    "Hunt for the Wilderpeople",
    "Hush",
    "I Am Divine",
    "I Am Not Your Negro",
    "I Lost My Body",
    "I’m Thinking of Ending Things",
    "Icarus",
    "Into the Inferno",
    "Into the Wild",
    "Jim & Andy: The Great Beyond - Featuring a Very Special, Contractually Obligated Mention of Tony Clifton",
    "Killing Them Softly",
    "Klaus",
    "Knock Down the House",
    "Lady Bird",
    "Lagaan: Once Upon a Time in India",
    "Lost Girls",
    "Loving",
    "Ma Rainey’s Black Bottom",
    "Mad Max",
    "Mank",
    "Marriage Story",
    "Mean Streets",
    "Menashe",
    "Mindhorn",
    "Miracle",
    "Monty Python and the Holy Grail",
    "Monty Python's Life of Brian",
    "Moonlight",
    "Mud",
    "Mudbound",
    "Nightcrawler",
    "No Direction Home: Bob Dylan",
    "Nocturnal Animals",
    "Okja",
    "Outside In",
    "Pan's Labyrinth",
    "Pick of the Litter",
    "Pineapple Express",
    "Private Life",
    "Rolling Thunder Revue: A Bob Dylan Story By Martin Scorsese",
    "Roma",
    "Sand Storm (Sufat Chol)",
    "Scott Pilgrim vs. the World",
    "Searching for Bobby Fischer",
    "Set It Up",
    "Shadow",
    "Shirkers",
    "Silver Linings Playbook",
    "Sin City",
    "Snowpiercer",
    "Song Of The Sea",
    "Spider-Man: Into the Spider-Verse",
    "Spotlight",
    "Starship Troopers",
    "Steve Jobs",
    "Strong Island",
    "Superbad",
    "Taxi Driver",
    "The Artist",
    "The Ballad of Buster Scruggs",
    "The Bling Ring",
    "The Breadwinner",
    "The Death of Stalin",
    "The Departed",
    "The Disaster Artist",
    "The Endless",
    "The Florida Project",
    "The Forty-Year-Old Version",
    "The Founder",
    "The Gift",
    "The Girl With the Dragon Tattoo",
    "The Half of It",
    "The Hateful Eight",
    "The Irishman",
    "The Killing of a Sacred Deer",
    "The Little Prince",
    "The Master",
    "The Meyerowitz Stories (New and Selected)",
    "The Muppets",
    "The One I Love",
    "The Other Guys",
    "The Perks of Being a Wallflower",
    "The Sapphires",
    "The Social Network",
    "The Square (Al Midan)",
    "The Squid and the Whale",
    "The Town",
    "The Two Popes",
    "There Will Be Blood",
    "To All the Boys I've Loved Before",
    "Total Recall",
    "Uncut Gems",
    "Undefeated",
    "Under The Shadow",
    "WarGames (War Games)",
    "We the Animals",
    "What’s Eating Gilbert Grape?",
    "Whose Streets?",
    "Wildlife",
    "Willy Wonka and the Chocolate Factory",
    "Yes, God, Yes",
]

best_of_2020_movies = [
    "13th",
    "1922",
    "20th Century Women",
    "A Clockwork Orange",
    "A Ghost Story",
    "A Shaun the Sheep Movie: Farmageddon",
    "A Single Man",
    "Alexander",
    "Always Be My Maybe",
    "American Factory",
    "American Me",
    "Aquarius",
    "At Eternity’s Gate",
    "Athlete A",
    "Atlantics",
    "Back to the Future",
    "Beasts of No Nation",
    "Blaze",
    "Blue Ruin",
    "Bonnie and Clyde",
    "Burning (Beoning)",
    "CAM",
    "Casino Royale",
    "Chinatown",
    "Circus of Books",
    "Cool Hand Luke",
    "Crazy Stupid Love",
    "Crimson Peak",
    "Crip Camp: A Disability Revolution",
    "Croupier",
    "Da 5 Bloods",
    "Dances With Wolves",
    "Dick Johnson is Dead",
    "Dolemite Is My Name",
    "El Camino: A Breaking Bad Movie",
    "Election",
    "Enola Holmes",
    "Fruitvale Station",
    "Fyre",
    "Gems",
    "Gerald's Game",
    "Get on Up",
    "Good",
    "Good Hair",
    "Good Time",
    "Happy as Lazzaro (Lazzaro felice)",
    "High Flying Bird",
    "His House",
    "Homecoming: A Film by Beyoncé",
    "How to Train Your Dragon 2",
    "Howards End",
    "Hugo",
    "Hunt for the Wilderpeople",
    "Hush",
    "I Am Divine",
    "I Am Mother",
    "I Am Not Your Negro",
    "I Lost My Body",
    "I’m Thinking of Ending Things",
    "Icarus",
    "Into the Inferno",
    "Into the Wild",
    "Irishman",
    "Jim & Andy: The Great Beyond - Featuring a Very Special, Contractually Obligated Mention of Tony Clifton",
    "Klaus",
    "Knock Down the House",
    "Lady Bird",
    "Lost Girls",
    "Loving",
    "Ma Rainey's Black Bottom",
    "Mad Max",
    "Mank",
    "Marriage",
    "Marriage Story",
    "Menashe",
    "Middle of Nowhere",
    "Million Dollar Baby",
    "Mindhorn",
    "Miss Americana",
    "Monty Python and the Holy Grail",
    "Monty Python's Life of Brian",
    "Moonlight",
    "Mudbound",
    "My Best Friend’s Wedding",
    "My Fair Lady",
    "Nightcrawler",
    "No Direction Home: Bob Dylan",
    "Nocturnal Animals",
    "Okja",
    "Outside In",
    "Pan's Labyrinth",
    "Paranorman",
    "Philomena",
    "Pick of the Litter",
    "Private Life",
    "Rain Man",
    "Recall",
    "Rocks",
    "Rolling Thunder Revue: A Bob Dylan Story By Martin Scorsese",
    "Roma",
    "Rush",
    "Sand Storm (Sufat Chol)",
    "Scott Pilgrim vs. the World",
    "Searching for Bobby Fischer",
    "Set It Up",
    "Shadow",
    "Shirkers",
    "Shutter Island",
    "Silver Linings Playbook",
    "Spotlight",
    "Stand by Me",
    "Starship",
    "Steve Jobs",
    "Story",
    "Strong Island",
    "Superbad",
    "Synchronic",
    "The",
    "The Artist",
    "The Ballad of Buster Scruggs",
    "The Big Lebowski",
    "The Bling Ring",
    "The Conjuring",
    "The Dark Knight",
    "The Death of Stalin",
    "The Departed",
    "The Disaster Artist",
    "The Endless",
    "The Florida Project",
    "The Forty-Year-Old Version",
    "The Founder",
    "The Girl With the Dragon Tattoo",
    "The Guest",
    "The Half of It",
    "The Hateful Eight",
    "The Irishman",
    "The Killing of a Sacred Deer",
    "The Kindergarten Teacher",
    "The Little Prince",
    "The Master",
    "The Meyerowitz Stories (New and Selected)",
    "The Mitchells vs. the Machines",
    "The Muppets",
    "The Outlaw Josey Wales",
    "The Pianist",
    "The Ring",
    "The Social Network",
    "The Square (Al Midan)",
    "The Squid and the Whale",
    "The Two Popes",
    "The White Tiger",
    "The Willoughbys",
    "There Will Be Blood",
    "Time",
    "To All the Boys I've Loved Before",
    "Total",
    "Training Day",
    "Troopers",
    "Uncorked",
    "Uncut",
    "Uncut Gems",
    "Undefeated",
    "Under The Shadow",
    "We the Animals",
    "What’s Eating Gilbert Grape?",
    "Whose Streets?",
    "Wildlife",
    "Willy Wonka and the Chocolate Factory",
    "Yes, God, Yes"
]

categories = {
    "Popular Movies": {
        "image":
        "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/popular-movies-year-born-1523052006.jpg?crop=1.00xw:1.00xh;0,0&resize=480:*",
        "url":
        "https://api.themoviedb.org/3/movie/popular?api_key={}&language=en-US&page="
        .format(movie_db_api_key),
        'front_page': False
    },
    "Top Rated Movies": {
        "image":
        "https://laffaz.com/wp-content/uploads/2020/02/top-inspirational-movies-entrepreneurs-startup-founders.jpg",
        "url":
        "https://api.themoviedb.org/3/movie/top_rated?api_key={}&language=en-US&page="
        .format(movie_db_api_key),
        'front_page': False
    },
    "Best of 2020": {
        "image":
        "https://blog.getpocket.com/wp-content/uploads/2020/11/Best_of_Pocket_2.gif",
        "url": False,
        'front_page': False
    },
    # "Christmas Movies": {
    #     "image":
    #     "https://media1.s-nbcnews.com/j/newscms/2019_48/1511759/holiday-movies-today-main-191122_7e3d4bc35a52711ae02f05ffaeacb114.fit-1240w.jpg",
    #     "url":
    #     "https://api.themoviedb.org/3/search/movie?api_key={}&language=en-US&query=christmas&page=1&include_adult=false&page="
    #     .format(movie_db_api_key)
    # },
    "Available on Netflix": {
        "image":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/69/Netflix_logo.svg/2560px-Netflix_logo.svg.png",
        "url": False,
        'front_page': True
    },
    "Available on Hulu": {
        "image":
        "https://cdn.mos.cms.futurecdn.net/7LuFVPSof9uCvmGJjUwzgL-1200-80.jpg",
        "url": False,
        'front_page': True
    },
    "Available on HBO Max": {
        "image":
        "https://variety.com/wp-content/uploads/2020/04/hbo-max.png",
        "url": False,
        'front_page': True
    },
    "Available on Amazon Prime Video": {
        "image":
        "https://www.androidcentral.com/sites/androidcentral.com/files/styles/w1600h900crop/public/article_images/2021/02/prime-video-logo.jpg",
        "url": False,
        'front_page': True
    },
}

# fetch url data


def fetch_url_data(url, num_pages):
    movies = []
    for n in range(1, num_pages + 1):
        new_url = url + str(n)
        json_data = json.loads(requests.get(new_url).content)
        for i in json_data['results']:
            movies.append(i)
    return movies


def fetch_url_data_page(url, page_number):
    movies = []
    new_url = url + str(page_number)
    json_data = json.loads(requests.get(new_url).content)
    for i in json_data['results']:
        movies.append(i)
    return movies


def find_streaming_platforms(url):
    page = 1
    streaming_services = {}
    while max(map(lambda x: len(streaming_services[x]), streaming_services), default=0) < 50:
        for m in fetch_url_data_page(url, page):
            data = find_streaming_services(m['title'])
            for d in data:
                # print(d)
                if d in streaming_services:
                    streaming_services[d].append(
                        m['title'])
                else:
                    streaming_services[d] = [m['title']]
            # print(m['title'])
            # print(data)
        page += 1

    return streaming_services


# s = find_streaming_platforms("https://api.themoviedb.org/3/movie/top_rated?api_key={}&language=en-US&page="
#                              .format(movie_db_api_key))

# for p in sorted(s):
#     print(p + ': ' + str(len(s[p])))

# fetch_url_data('https://api.themoviedb.org/3/movie/popular?api_key={}&language=en-US&page='.format(
#     movie_db_api_key), num_pages)

# fetch movie data


def generate_list(url, number_of_movies):
    movies = []
    pages = number_of_movies // 20
    for i in range(1, pages + 1):
        movies = movies + (fetch_url_data_page(url, i))
    return movies


# popular_list = generate_list(popular_url, 10000)
# top_rated_list = generate_list(top_rated_url, 10000)

popular_list = generate_list(popular_url, 5000)


def populate_streaming_services(movie_list):
    streaming_list = movie_list
    for n, title in enumerate(streaming_list):
        # print(title['title'])
        # print(find_streaming_services(title['title']))
        streaming_list[n]['streaming'] = find_streaming_services(
            title['title'])
        # print('\n' * 2)
        # time.sleep(2)
    return streaming_list


def generate_streaming_services_list(completed_streaming_list):
    streaming_services = {}
    for t in completed_streaming_list:
        # print(t)
        for s in t['streaming']:
            service = list(s.keys())[0]
            if service in streaming_services:
                streaming_services[service].append(
                    t['title'])
            else:
                streaming_services[service] = [t['title']]
    return streaming_services


streaming_services = generate_streaming_services_list(
    populate_streaming_services(popular_list))


def print_by_name(streaming_services):
    for s in sorted(streaming_services):
        print(s + ': ' + str(len(streaming_services[s])))


def print_by_count(streaming_services):
    for s in sorted(streaming_services, key=lambda k: len(
            streaming_services[k]), reverse=True):
        print(s + ": " + str(len(streaming_services[s])))


def print_not_found(streaming_services):
    for i in streaming_services['Movie Not Found']:
        print(i)


def print_no_streaming_available(streaming_services):
    for i in streaming_services['No Streaming Available']:
        print(i)


def print_not_found_n(streaming_services, n=10):
    for i in range(n):
        print(random.choice(streaming_services['Movie Not Found']), end="\n")


def print_no_streaming_available_n(streaming_services, n=10):
    for i in range(n):
        print(random.choice(
            streaming_services['No Streaming Available']), end="\n")


def get_streaming_service_movies(streaming_services, streaming_service):
    return streaming_services[streaming_service]


# print_not_found(streaming_services)
# print_no_streaming_available(streaming_services)


def fetch_movie_data(movies):
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
                'Streaming': streaming_services
            })
        except Exception as e:
            errors.append(movie)
            # print(e)
    print("{} errors occured".format)
    # print(errors)
    return movie_data


def create_banner_data():
    bannerData = []
    for cat in categories:
        new_banner = {}
        new_banner['Title'] = cat
        new_banner['ImageUrl'] = categories[cat]['image']
        new_banner['FrontPage'] = categories[cat]['front_page']

        if categories[cat]['url']:
            movie_data = fetch_movie_data(
                fetch_url_data(categories[cat]['url'], num_pages))

        elif not categories[cat]['url'] and cat == 'Available on Netflix':
            movie_data = fetch_movie_data(get_streaming_service_movies(
                streaming_services, 'Netflix'))
        elif not categories[cat]['url'] and cat == 'Available on Hulu':
            movie_data = fetch_movie_data(get_streaming_service_movies(
                streaming_services, 'Hulu'))
        elif not categories[cat]['url'] and cat == 'Available on HBO Max':
            movie_data = fetch_movie_data(get_streaming_service_movies(
                streaming_services, 'HBO Max'))
        elif not categories[cat]['url'] and cat == 'Available on Amazon Prime Video':
            movie_data = fetch_movie_data(get_streaming_service_movies(
                streaming_services, 'Amazon Prime Video'))

        elif not categories[cat]['url'] and cat == 'Best of 2020':
            movie_data = fetch_movie_data(best_of_2020_movies)
        new_banner['Data'] = movie_data

        bannerData.append(new_banner)

    return bannerData


d = create_banner_data()


# d_json = json.dumps({'data': d})
# print(d_json)

# with open(r"C:\Users\taylo\Desktop\upick_data.json", 'w') as f:
#     json.dump(d, f)


config = {
    'apiKey': "AIzaSyAEespYo4MImAl0izGX4crFWIljLUhQW5Y",
    'authDomain': "upick-775b7.firebaseapp.com",
    'databaseURL': "https://upick-775b7.firebaseio.com",
    'projectId': "upick-775b7",
    'storageBucket': "upick-775b7.appspot.com"
}


config_test = {
    'apiKey': "AIzaSyAEespYo4MImAl0izGX4crFWIljLUhQW5Y",
    'authDomain': "upick-775b7.firebaseapp.com",
    'databaseURL': "https://upick-775b7-bb6c3.firebaseio.com",
    'projectId': "upick-775b7",
    'storageBucket': "upick-775b7.appspot.com"
}

# firebase = Firebase(config)
firebase = Firebase(config_test)

auth = firebase.auth()

db = firebase.database()

data = db.get().val()


def save_data(data):
    db.child('').set(data)


# save_data(d)


# sample data
# {
#     "Cast": "Melina Abdullah, Michelle Alexander, Cory Booker, Dolores Canales",
#     "Director": "Ava DuVernay",
#     "Genres": "Documentary, Crime, History",
#     "Plot": "An in-depth look at the prison system in the United States and how it reveals the nation's history of racial inequality.",
#     "Poster": "https://m.media-amazon.com/images/M/MV5BMjAwMjU5NTAzOF5BMl5BanBnXkFtZTgwMjQwODQxMDI@._V1_SX300.jpg",
#     "Rated": "TV-MA",
#     "Rating": "8.3",
#     "Runtime": "100 min",
#     "Title": "13th",
#     "Year": "2016",
#     "imdbID": "tt5895028",
#     "streaming_platforms": []
# }


if __name__ == '__main__':
    pass
