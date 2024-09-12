import re
import requests
import csv
import time

# Replace 'your_github_access_token' with your actual GitHub Personal Access Token
GITHUB_TOKEN = 'your_github_access_token'
SEARCH_QUERY_BASE = '"arn:aws:iam::" language:yaml OR "arn:aws:iam::" language:hcl'

# Headers for GitHub API request
headers = {
    'Authorization': f'token {GITHUB_TOKEN}',
    'Accept': 'application/vnd.github.v3+json'
}

# GitHub search code URL
SEARCH_URL = 'https://api.github.com/search/code'

# Exclude patterns
exclude_patterns = [
    r'jenkins',
    r'harness',
    r'p\d{6}/.*',
    r'aws-lz\d{3}'
]

# File containing the list of organizations
organization_file = 'organizations.txt'


def search_github(query, headers, page=1):
    params = {
        'q': query,
        'per_page': 100,
        'page': page
    }
    response = requests.get(SEARCH_URL, headers=headers, params=params)
    response.raise_for_status()
    return response.json()


def write_to_csv(matching_repos, filename='results.csv'):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['Repository Full Name'])
        for full_name in matching_repos:
            writer.writerow([full_name])
    print(f"Results written to {filename}")


def read_organizations(file_path):
    with open(file_path, 'r') as file:
        return [line.strip() for line in file if line.strip()]


def main():
    matching_repos = set()

    # Read the list of organizations from file
    organizations = read_organizations(organization_file)

    request_counter = 0
    start_time = time.time()

    # Iterate over the list of organizations
    for org in organizations:
        partitioned_query = f"{SEARCH_QUERY_BASE} org:{org}"

        page = 1
        while True:
            try:
                data = search_github(partitioned_query, headers, page)
                items = data.get('items', [])

                if not items:
                    break

                for item in items:
                    repository_full_name = item['repository']['full_name']

                    # Logging each repository being processed
                    print(f"Processing repository: {repository_full_name}")

                    # Check if any of the exclude patterns are found in the repo full name
                    if any(re.search(pattern, repository_full_name, re.IGNORECASE) for pattern in exclude_patterns):
                        print(f"Excluded repository: {repository_full_name}")
                        continue

                    matching_repos.add(repository_full_name)

                page += 1

                # Increment the request counter
                request_counter += 1

                # Check the requests per minute condition
                if request_counter == 30:
                    elapsed_time = time.time() - start_time
                    if elapsed_time < 60:
                        sleep_time = 60 - elapsed_time
                        print(f"Reached 30 requests. Sleeping for {sleep_time} seconds.")
                        time.sleep(sleep_time)
                    # Reset the counter and start time
                    request_counter = 0
                    start_time = time.time()

            except Exception as e:
                print(f"An error occurred: {e}")
                break

    if matching_repos:
        write_to_csv(matching_repos)
    else:
        print("No matches found.")


if __name__ == "__main__":
    main()
