import requests
from bs4 import BeautifulSoup
import pprint

url_stub = "https://www.justwatch.com/us/movie/"
movie_name = "Unaccompanied Minors"


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
        r = requests.get(url_stub + convert_movie_name(movie_name))
        soup = BeautifulSoup(r.content, 'html.parser')
        # stream_row = soup.find(
        #     "div", {"class": "price-comparison__grid__row price-comparison__grid__row--stream"})
        # if 'monetizations' in stream_row.parent['class']:
        #     stream_row = soup.find_all(
        #         "div", {"class": "price-comparison__grid__row price-comparison__grid__row--stream"})[1]
        monetizations_row = soup.find_all(
            "div", {"class": "monetizations"})[-1]
        stream_row = monetizations_row.find(
            "div", {"class": "price-comparison__grid__row price-comparison__grid__row--stream"})
        try:
            stream_elements = stream_row.find_all(
                "div", {"class": "price-comparison__grid__row__element"})

            if stream_elements == []:
                return [{'No Streaming Available': ''}]

            else:
                for e in stream_elements:
                    streaming_services.append(
                        {e.find('img')['title']: e.find('img').parent['href']})
        except Exception as e:
            return [{'No Streaming Available': ''}]

        return streaming_services
    except Exception as e:
        # print('An error occured or no streaming platforms are available')
        return [{'Movie Not Found': ''}]


# print(find_streaming_services(movie_name))

if __name__ == '__main__':
    pprint.pprint(find_streaming_services(movie_name))
