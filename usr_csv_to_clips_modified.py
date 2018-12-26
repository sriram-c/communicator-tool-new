# Objective
#   Given the usr_csv file for a language, generate the clip facts.
#   it is done for hindi
############################################################################################################
import sys
import os
import re
import math

def main():
    #input_file_pathdir="/home/versha/communicator-tool-master/user_csv/"
    #output_file_pathdir="/home/versha/project_programs/output_clipfacts/"
    f=open(sys.argv[1],'r')
    ans=open(sys.argv[2],'w+')
    l=list(f)
    for i in range(0,len(l)):  # to remove the leading and lagging spaces
        l[i]=l[i].strip()

    # rownames contain the names for the rows in the usr_csv as per the user_schema
    rownames=[]
    f2=open("usr-schema",'r')
    l2=list(f2)
    for i in range(0,len(l2)):
        l2[i]=l2[i].strip()
    for i in range(0,len(l2)):
        rownames.append(l2[i].split()[1])


    group = []          #row 1
    concpt_dic = []     #row 2
    wid = []            #row 3
    pos = []            #row 4
    gnp = []            #row 5
    intra_chk=[]        #row 6
    inter_chk = []      #row 7
    disc_rel=[]         #row 8
    sent_type=[]        #row 9
    invindex=[]         #to store indices which dont have post positions
    tamindex=[]         #storing indices of the groups which have tam values.
    group=l[0].split(",")
    concpt_dic=l[1].split(",")
    wid=l[2].split(",")
    pos=l[3].split(",")
    gnp=l[4].split(",")
    intra_chk=l[5].split(",")
    inter_chk=l[6].split(",")
    disc_rel=l[7].split(",")
    sent_type=l[8]

    id_concept_map=[]
    concept=[]
    id=[]
    head=[]
    whq=0
    neg=0
    imper=0
    h1=""
    disc_rel_id=0
    emp_words={}
    pp={}
    emp=[]

    # finding index of tam:  we store in tamindex
    for i in range(0,len(group)):
        if group[i].find('-')!=-1:
            tamindex.append(i)
            invindex.append(i)
        if group[i].find('_')==-1:
            invindex.append(i)

    # finding head_id and giving id to all the tokens and finding the postposition for all head concept_labels
    for i in range(0,len(group)):
        # condition 1
        if group[i].find("_")!=-1 and i not in tamindex:
            # former condn is for senetnces having concept "kya"
            if (group[i].find("*")!=-1):    # when the chunk contains emphatic words
                hstring=""  # storing the head concept_label
                match=re.search(r'\w+\*',group[i])
                if match:
                    hstring=match.group()
                    hstring=hstring[:len(hstring)-1]
                s=re.findall(r'\w+',group[i])
                for j in range(0,len(s)):
                    if hstring==s[j]:
                        head.append(str(i+1)+"."+str(j+1))
                        pp[str(i+1)+"."+str(j+1)]=hstring.split("_")[1]
                    id.append(str(i+1)+"."+str(j+1))

            elif (group[i].find("*")==-1):  # when the chunk doesnt contain emphatic words
                s=re.findall(r'\w+',group[i])
                if len(s)>1:
                    # the head_concept label will be the last concept in this case
                    head.append(str(i+1)+"."+str(len(s)))
                    pp[str(i+1)+"."+str(len(s))]=s[len(s)-1].split("_")[1]
                    for j in range(0,len(s)):
                        id.append(str(i+1)+"."+str(j+1))
                else:
                    id.append(str(i+1))
                    head.append(str(i+1))
                    pp[str(i+1)]=s[len(s)-1].split("_")[1]

        # condition 2
        if i in tamindex:
            id.append(str(i+1))
            head.append(str(i+1))

        # condition 3
        if group[i].isalpha() == True:
            id.append(str(i+1))
            head.append(str(i+1))

    for i in range(0,len(concpt_dic)):
        if concpt_dic[i].find("~")!=-1 or concpt_dic[i].find("*")!=-1:
            s=re.split(r'[/*/~]',concpt_dic[i])
            for j in range(0,len(s)):
                concept.append(s[j])
        else:
            concept.append(concpt_dic[i])

    id_concept_map={i:j for i,j in zip(id,concept)}

    #providing emp id
    for i in range(0,len(concpt_dic)):
        emp_name=re.findall(r'\w\*\w+\~',concpt_dic[i])
        last_emp=re.findall(r'\*\w+\Z',concpt_dic[i])
        for j in range(0,len(emp_name)):
            emp_name[j]=emp_name[j][1:len(emp_name[j])-1]
            emp.append(emp_name[j])
            emp_words[(head[i]+1)*10000]=emp_name[j]
        if last_emp:
            emp_words[(i+1)*10000]=last_emp[0].strip()[1:]
            emp.append(last_emp[0].strip()[1:])

    # writing id-concept
    for k in id_concept_map.keys():
        if id_concept_map[k]!="" and id_concept_map[k] not in emp:
            idd=str(int(float(k)*10000))
            ans.write("(id-concept_label\t"+idd+" "+id_concept_map[k]+")\n")

    # writing emp ids
    for x in emp_words.keys():
        ans.write("(id-emp\t"+str(x)+" "+str(emp_words[x])+")\n")

    # writing gender,number,person:
    for i in range(0,len(gnp)):
        if(len(gnp[i])>1):
            s=gnp[i]
            s=s[1:len(s)-1]
            gnp[i]=s
    for i in range(0,len(wid)):
        if gnp[i]!="":
            hedd=str(int(float(head[i])*10000))
            ans.write("(id-gen-num-pers\t"+hedd+" "+gnp[i]+")\n")

    # writing pos values
    for i in range(0,len(wid)):
        category_id=str(int(float(head[i])*10000))
        if pos[i]=="yes_no_qsn":
            whq=1
        elif pos[i]!="":
            ans.write("(id-"+pos[i]+"\t"+category_id+" "+"yes)\n")

    # writing inter_chk:
    t=()
    for i in range(0,len(wid)):
        inter_chk_id=str(int(float(head[i])*10000))
        if inter_chk[i]!="":
            t=inter_chk[i].split(":")
            icid=str(int(float(t[0])*10000))
            inter_chunk=t[1]

            if (inter_chunk=='k1') or (inter_chunk=='k2'):
                ans.write("(kriyA-"+inter_chunk+"\t"+icid+" "+inter_chk_id+")\n")
            #ans.write("("+map_inter_chk[t[1]]+"\t"+icid+" "+inter_chk_id+")\n")

            else:
                ans.write("(rel_name-ids kriyA-"+inter_chunk+"\t"+icid+" "+inter_chk_id+")\n")


    # writing tam value
    for i in range(0,len(tamindex)):
        ans.write("(kriyA-TAM\t"+str((tamindex[i]+1)*10000)+" "+group[tamindex[i]].split("-")[1]+")\n")

    # discourse relations
    for i in range(0,len(disc_rel)):
        if len(disc_rel)>1:
            if disc_rel[i].find("neg")!=-1:
                neg=1
                f=disc_rel[i].find(":")
                a=int(disc_rel[i][:f])
                kriyaid=str(int(float(head[i])*10000))
                negid=str(int(float(head[a-1])*10000))
                ans.write("(kriyA-NEG\t"+negid+" "+kriyaid+")\n")
            if disc_rel[i].find("co-ref")!=-1:
                f=disc_rel[i].find(":")
                a=int(disc_rel[i][:f])
                viSeRyaid=str(int(float(head[i])*10000))
                corefid=str(int(float(head[a-1])*10000))
                ans.write("(viSeRya-co_reference\t"+viSeRyaid+" "+corefid+")\n")
            if disc_rel[i].find("emp")!=-1:
                f=disc_rel[i].find(":")
                disc_rel_id=disc_rel[i][:f]
                h1=str(int(float(disc_rel_id)*10000))
                if head[i]==disc_rel_id:
                    ans.write("(viSeRya-emp\t"+h1+" "+str((i+1)*10000)+")\n")
                else:
                    ans.write("(viSeRaNa-emp\t"+h1+" "+str((i+1)*10000)+")\n")

    # intra chunk relations
    for i in range(0,len(intra_chk)):
         if(len(intra_chk[i])>1):
             if(intra_chk[i].find("~"))!=-1:
                 z=intra_chk[i].split("~")
                 for j in range(0,len(z)):
                     f=intra_chk[i].index(":")
                     x=z[j][f+1:].replace("-","_")
                     viseshyaid=intra_chk[i][:f]
                     vshy_id=str(int(float(viseshyaid)*10000))
                     temp=viseshyaid[:viseshyaid.index(".")]
                     viseranaid=temp+"."+str(j+1)
                     vsrn_id=str(int(float(viseranaid)*10000))
                     ans.write("(viSeRya-"+x+" "+vshy_id+" "+vsrn_id+")\n")
             else:
                 f=intra_chk[i].index(":")
                 x=intra_chk[i][f+1:].replace("-","_")
                 viseshyaid=intra_chk[i][:f]
                 vshy_id=str(int(float(viseshyaid)*10000))
                 temp=viseshyaid[:viseshyaid.index(".")]
                 viseranaid=temp+".1"
                 vsrn_id=str(int(float(viseranaid)*10000))
                 ans.write("(viSeRya-"+x+" "+vshy_id+" "+vsrn_id+")\n")

    # writing sentence type
    ans.write("(sentence_type\t"+str(sent_type)+")\n")

    # writing post positions
    for x in pp.keys():
        PSP_id=str(int(float(x)*10000))
        ans.write("(viSeRya-PSP\t"+PSP_id+" "+pp[x]+")\n")
main()
