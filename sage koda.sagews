︠553cfa07-5be3-4703-b374-5f23bd87538c︠
#MAKSIMALNE NEODVISNE MNOŽICE
def maksimalne_neodvisne_mnozice(G):
    mnozice = [] #ustvari prazen seznam
    pregledane = set() #ustvari prazno mnozico

    def backtrack(A, B):
        if len(B) == 0: #če smo šli že skozi vsa vozlišča v grafu
            mnozice.append(A) #potemn seznamu množice dodamo množico A
        for v in B: #vzame eno vozlišče grafa
            C = A + Set([v]) #naredimo novo množico C, ki že obstoječi množici A doda vozlišče v
            if C in pregledane: #potrebujemo, da se iste množice nebi ponavljale za vsako vozlišče
                continue
            pregledane.add(C)
            backtrack(C, B - G[v] - [v]) # ponovno izvede fuknsijo, samo da sedaj za množico A vzame množico C, ki ni prazna,
                                         # za množico B pa vsa vozlišča, ki niso sosednja z vozliščem v in niso vozlišče v

    backtrack(Set(), Set(G)) # ko do konca pregledamo eno vozlišče, ponovimo funkcijo backtrack
    
    return mnozice

#NEODVISNOSTNO ŠTEVILO
def independence_number(G):
    A = 0 #vpeljemo kazalec A
    mn = maksimalne_neodvisne_mnozice(G) #izvedemo maksimalne_neodvisne_mnozice(G)
    for i in mn: #pregledamo vse maksimalne neodvisne množice
        if len(i) > A: #primerjamo njihove velikosti
            A = len(i) #poiščemo največjo
    return A
        

#KROMATIČNO ŠTEVILO

def kromaticno_stevilo(G):
    n=G.order() #n predstavlja število vozlišč grafa
    p = MixedIntegerLinearProgram(maximization = False) #linearni program, kjer iščemo minimum
    x = p.new_variable(binary = True) #nova realna, nenegativna spremenljivka x
    y = p.new_variable(binary = True) #nova realna, nenegativna spremenljivka y
    p.set_objective(sum ([y[i] for i in range(n)])) #iščemo minimum vsote y[i]
    for u in G:
        p.add_constraint(sum([x[u,i] for i in range(n)])== 1) #vsako vozlišče mora biti točno ene barve

    for u,v in G.edges(labels = False):
        for i in range(n):
            p.add_constraint( x[u,i] + x[v,i] <= 1 ) #sosednji vozlišči ne smeta biti iste barve

    for u in G:
        for i in range(n):
            p.add_constraint( x[u,i] <= y[i]) #če je katerokoli vozlišče barve i, mora y[i] pokazati 1

    res = p.get_values(x)
    return p.solve()


#KLIČNO ŠTEVILO

def klicno_stevilo(G):
    g = G.complement() #zapišemo komplement grafa
    n=g.order() #n predstavlja število vozlišč
    p = MixedIntegerLinearProgram(maximization = True) #linearni program, kjer iščemo maksimum
    x = p.new_variable(binary = True) #nova realna, nenegativna spremenljivka x
    p.set_objective(sum([x[i] for i in range(n)])) #iščemo maksimum vsote x[i]
    for u,v in g.edges(labels=False):
        p.add_constraint(x[u] + x[v] <=1) #sosednji vozlišči v komplementu grafa ne smeta biti v isti kliki
    res2 = p.get_values(x)
    return p.solve()

#DELJENO KROMATIČNO IN KLIČNO ŠTEVILO

def deljeno_kromaticno_stevilo(G, mnozice=None):
    if mnozice is None: # če nimamo definiranega seznama z maksimalnimi neodvisnimi množicami, ga sedaj s pomočjo funkcije
        mnozice = maksimalne_neodvisne_mnozice(G)   # maksimalne<-neodvisne_mnozice(G) definiramo
    m = len(mnozice) #m predstavlja število maksimalnih neodvisnih množic grafa G
    n = G.order()  #n prestravlja število vozlišč grafa G
    p = MixedIntegerLinearProgram(maximization = False) #linearni program, kjer iščemo minimum
    y = p.new_variable(real=True, nonnegative=True) #def. realno in nenegativno spremenljivko y
    p.set_objective(sum([y[i] for i in range(m)])) #iščemo min vsote y[i]
    for v in G:
        p.add_constraint(sum(y[i] for i in range(m) if v in mnozice[i]) >= 1) #vsako vozlišče se mora vsaj enkrat pojaviti v mnozici

    return p.solve()

def deljeno_klicno_stevilo(G, mnozice=None):
    if mnozice is None:  # če nimamo definiranega seznama z maksimalnimi neodvisnimi množicami, ga sedaj s pomočjo funkcije
        mnozice = maksimalne_neodvisne_mnozice(G) # maksimalne<-neodvisne_mnozice(G) definiramo
    m = len(mnozice)  #m predstavlja število maksimalnih neodvisnih množic grafa G
    n = G.order()     #n prestravlja število vozlišč grafa G
    p = MixedIntegerLinearProgram(maximization = True) #linearni program, kjer iščemo maksimum
    y = p.new_variable(real=True, nonnegative=True)        #def. realno in nenegativno spremenljivko y
    p.set_objective(sum([y[v] for v in G]))               #iščemo max vsote y[v]
    for i in range(m):
        p.add_constraint(sum(y[v] for v in mnozice[i]) <= 1) # v vsaki maksimalni neod. mn. se vsako vozlišče lahko pojavi največ enkrat

    return p.solve()
︡5468a1c1-fe37-4546-9505-f2ca9868555b︡{"done":true}︡
︠876deac5-fb23-403e-899f-b4dbfd83983fs︠

︡41c2f3a0-1741-4113-9f12-a8f84f55a691︡{"done":true}︡
︠2db17810-2ae8-4f7e-9789-8921f912011cs︠

# preizkus na Kneserjevem  grafu
G = graphs.KneserGraph(5,2)
G.relabel()
mnozice = maksimalne_neodvisne_mnozice(G)
mnozice
kromaticno_stevilo(G)
klicno_stevilo(G)
deljeno_kromaticno_stevilo(G, mnozice)
deljeno_klicno_stevilo(G, mnozice)
independence_number(G)
G.order()*(independence_number(G))^(-1)


#preizkus na "hypercube" grafu
H = graphs.CubeGraph(4);
H.relabel()
mnozice = maksimalne_neodvisne_mnozice(H)
mnozice
kromaticno_stevilo(H)
klicno_stevilo(H)
deljeno_kromaticno_stevilo(H, mnozice)
deljeno_klicno_stevilo(H, mnozice)
independence_number(H)
H.order()*(independence_number(H))^(-1)

#preizkus na krožnem grafu
K = graphs.CirculantGraph(13,2)
K.relabel()
mnozice = maksimalne_neodvisne_mnozice(K)
mnozice
kromaticno_stevilo(K)
klicno_stevilo(K)
deljeno_kromaticno_stevilo(K, mnozice)
deljeno_klicno_stevilo(K, mnozice)
independence_number(K)
K.order()*(independence_number(K))^(-1)

︡8d79369a-8067-4aef-8c99-1a92bfa87975︡{"stdout":"[{0, 9, 2}, {0, 2, 5, 7}, {0, 9, 4, 6}, {0, 4, 5}, {0, 6, 7}, {8, 1, 3}, {1, 3, 4, 5}, {1, 4, 6}, {1, 5, 7}, {8, 1, 6, 7}, {8, 9, 2, 3}, {2, 3, 5}, {8, 2, 7}, {9, 3, 4}, {8, 9, 6}]\n"}︡{"stdout":"3.0"}︡{"stdout":"\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.5\n"}︡{"stdout":"2.5000000000045\n"}︡{"stdout":"4\n"}︡{"stdout":"2.5\n"}︡{"stdout":"[{0, 3, 5, 6, 9, 10, 12, 15}, {0, 9, 3, 5, 14}, {0, 10, 3, 13, 6}, {0, 3, 13, 14}, {0, 11, 12, 5, 6}, {0, 11, 5, 14}, {0, 11, 13, 6}, {0, 9, 10, 12, 7}, {0, 9, 14, 7}, {0, 10, 13, 7}, {0, 11, 12, 7}, {0, 11, 13, 14, 7}, {1, 2, 4, 7, 8, 11, 13, 14}, {8, 1, 2, 4, 15}, {1, 2, 11, 12, 7}, {1, 2, 12, 15}, {1, 10, 4, 13, 7}, {1, 10, 4, 15}, {8, 1, 11, 13, 6}, {8, 1, 6, 15}, {1, 10, 12, 6, 15}, {1, 10, 13, 6}, {1, 11, 12, 6}, {1, 10, 12, 7}, {9, 2, 4, 14, 7}, {9, 2, 4, 15}, {8, 2, 11, 5, 14}, {8, 2, 5, 15}, {9, 2, 12, 5, 15}, {9, 2, 5, 14}, {2, 11, 12, 5}, {9, 2, 12, 7}, {8, 3, 4, 13, 14}, {8, 3, 4, 15}, {9, 10, 3, 4, 15}, {9, 3, 4, 14}, {10, 3, 4, 13}, {8, 3, 5, 6, 15}, {8, 3, 5, 14}, {8, 3, 13, 6}, {9, 10, 4, 7}, {8, 11, 5, 6}]\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.0000000000135008\n"}︡{"stdout":"8"}︡{"stdout":"\n"}︡{"stdout":"2.0"}︡{"stdout":"\n"}︡{"stdout":"[{0, 1, 4, 5, 8, 9}, {0, 1, 4, 8, 7}, {0, 1, 4, 5, 9, 10}, {0, 1, 10, 4, 7}, {0, 1, 5, 6, 9, 10}, {0, 1, 10, 6, 7}, {0, 3, 4, 8, 9, 12}, {0, 3, 4, 7, 8, 12}, {0, 9, 10, 3, 4}, {0, 10, 3, 4, 7}, {0, 9, 10, 3, 6}, {0, 9, 3, 12, 6}, {0, 10, 3, 6, 7}, {0, 3, 12, 6, 7}, {0, 4, 5, 8, 9, 12}, {0, 9, 12, 5, 6}, {8, 1, 2, 5, 9}, {8, 1, 2, 11, 5}, {1, 2, 5, 6, 9, 10}, {1, 2, 5, 6, 10, 11}, {1, 2, 6, 7, 10, 11}, {8, 1, 2, 11, 7}, {8, 1, 11, 4, 5}, {1, 10, 11, 4, 5}, {8, 1, 11, 4, 7}, {1, 10, 11, 4, 7}, {9, 2, 3, 10, 6}, {9, 2, 3, 12, 6}, {2, 3, 6, 7, 10, 11}, {2, 3, 6, 7, 11, 12}, {2, 3, 7, 8, 11, 12}, {8, 9, 2, 3, 12}, {2, 11, 12, 5, 6}, {9, 2, 12, 5, 6}, {8, 2, 11, 12, 5}, {8, 9, 2, 12, 5}, {3, 4, 7, 8, 11, 12}, {3, 10, 11, 4, 7}, {8, 4, 11, 12, 5}]\n"}︡{"stdout":"3.0"}︡{"stdout":"\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.166666666666667\n"}︡{"stdout":"2.1666666666764454\n"}︡{"stdout":"6"}︡{"stdout":"\n"}︡{"stdout":"2.1666666666666665"}︡{"stdout":"\n"}︡{"done":true}︡












