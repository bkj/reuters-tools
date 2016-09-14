import re
import sys
import codecs
from bs4 import BeautifulSoup

sys.stdin  = codecs.getreader("utf-8")(sys.stdin)
sys.stdout = codecs.getwriter("utf-8")(sys.stdout)

counter = 0
for path in sys.stdin:
    path = path.strip()
    
    soup = BeautifulSoup(open(path).read(), 'lxml')
    
    labs = soup.findAll('code')
    labs = [l.attrs['code'] for l in labs]
    labs = filter(lambda l: l in ['CCAT', 'MCAT', 'ECAT', 'GCAT'], labs)
    if len(labs) == 1:
        text = soup.find('text').text.strip()
        text = re.sub('\t', '  ', text)
        text = ' '.join(text.splitlines())
    
        print '\t'.join([path, labs[0], text])