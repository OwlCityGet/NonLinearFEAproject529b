# Program to process input file
infi=open('FEA3D20_element_temp.txt','r')
outfi1=open('FEA3D20_element_temp1.txt','w')
outfi2=open('FEA3D20_element_temp2.txt','w')

total_line=0;
for line in infi:
    total_line+=1

infi.close()


infi=open('FEA3D20_element_temp.txt','r')
i=1

for j in range(int(total_line)):
    t=infi.readline()
    if i%2==1:
        outfi1.write(t)
        i+=1
    elif i%2==0:
        outfi2.write(t)
        i=1
infi.close()
outfi1.close()
outfi2.close()

outfi1=open('FEA3D20_element_temp1.txt','r')
outfi2=open('FEA3D20_element_temp2.txt','r')
outfi=open('FEA3D20_element.txt','w')


for j in range(int(total_line/2)):
    o1=outfi1.readline().strip()
    o2=outfi2.readline().strip()
    o3=o1+' '+o2+'\n'
    outfi.write(o3)

outfi1.close()
outfi2.close()
outfi.close()
