import argparse
from bs4 import BeautifulSoup

def main():
    # Set up the argument parser
    parser = argparse.ArgumentParser(description="Extract h3 tags from an HTML file.")
    parser.add_argument("filename", help="The HTML file to process.")
    
    # Parse the command-line arguments
    args = parser.parse_args()
    
    # Read the HTML file
    with open(args.filename, 'r', encoding='utf-8') as file:
        html_content = file.read()
    
    # Parse the HTML using BeautifulSoup
    soup = BeautifulSoup(html_content, 'lxml')
    
    # Find all h3 tags
    h3_tags = soup.find_all('h3')
    
    # Print the text of each h3 tag
    for h3 in h3_tags:
        print(h3.text)

if __name__ == "__main__":
    main()
