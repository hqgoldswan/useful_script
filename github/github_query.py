import re
import requests
import csv
from collections import defaultdict

# Replace 'your_github_access_token' with your actual GitHub Personal Access Token
GITHUB_TOKEN = 'your_github_access_token'
SEARCH_QUERY = 'arn:aws:iam:: language:yaml OR arn:aws:iam:: language:hcl'

# Headers for GitHub API request
headers = {
    'Authorization': f'token {GITHUB_TOKEN}'
}

# GitHub search code URL
SEARCH_URL = 'https://api.github.com/search/code'


def search_github(query, headers):
    params = {
        'q': query,
        'per_page': 100
    }
    response = requests.get(SEARCH_URL, headers=headers, params=params)
    response.raise_for_status()
    return response.json()


def download_file_content(file_url):
    response = requests.get(file_url, headers=headers)
    response.raise_for_status()
    return response.text


def find_pattern_in_content(pattern, content):
    regex = re.compile(pattern)
    return regex.findall(content)


def write_to_csv(results, filename='results.csv'):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['Repository Full Name', 'Matched Content'])
        for full_name, matches in results.items():
            matched_text = ' '.join(matches)
            writer.writerow([full_name, matched_text])
    print(f"Results written to {filename}")


def main():
    results = defaultdict(list)
    pattern = r'arn:aws:iam::[\w-]+:[\w-]+'
    try:
        data = search_github(SEARCH_QUERY, headers)
        for item in data.get('items', []):
            repository_full_name = item['repository']['full_name']
            # Exclude repositories with "Jenkins" or "harness" in name, case insensitive
            if re.search(r'jenkins|harness', repository_full_name, re.IGNORECASE):
                continue
            file_url = item['html_url']
            try:
                content = download_file_content(file_url)
                matches = find_pattern_in_content(pattern, content)
                if matches:
                    results[repository_full_name].extend(matches)
            except Exception as e:
                print(f"Failed to process {file_url}: {e}")

        if results:
            write_to_csv(results)
        else:
            print("No matches found.")
    except Exception as e:
        print(f"An error occurred: {e}")


if __name__ == "__main__":
    main()
