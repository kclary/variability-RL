import csv

# load file
f = []
with open('ALE agent scores - Raw scores.tsv', newline='') as tsvfile:
    reader = csv.reader(tsvfile, delimiter='\t')
    results = list(reader)
    f.append(results)

# unlist
f = f[0]
#headers = f[0]
#f = f[1:]

# remove text below headers
for i in range(0,10): 
	for j in range(1,101): 
		f[j][i] = f[j][i].split(":")[1].strip()

with open("raw_scores.tsv", "w") as outfile:
    writer = csv.writer(outfile, delimiter='\t')
    writer.writerows(f)