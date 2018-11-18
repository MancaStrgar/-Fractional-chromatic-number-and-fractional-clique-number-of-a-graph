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
            backtrack(C, B - G[v] - [v]) # ponovno izvede fuknsijo, samo da sedaj za množico A vzame množico C, ki ni prazna, za množico B pa vsa vozlišča, ki niso sosednja
                                         # z vozliščem v in niso vozlišče v

    backtrack(Set(), Set(G)) # za pvi korak vzame A kot prazno množico, za B pa množico vseh vozlišč
    return mnozice


#KROMATIČNO ŠTEVILO

def kromaticno_stevilo(G):
    n=G.order()
    p = MixedIntegerLinearProgram(maximization = False)
    x = p.new_variable(binary = True)
    y = p.new_variable(binary = True)
    p.set_objective(sum ([y[i] for i in range(n)]))
    for u in G:
        p.add_constraint(sum([x[u,i] for i in range(n)])== 1)

    for u,v in G.edges(labels = False):
        for i in range(n):
            p.add_constraint( x[u,i] + x[v,i] <= 1 )

    for u in G:
        for i in range(n):
            p.add_constraint( x[u,i] <= y[i])

    res = p.get_values(x)
    return p.solve()


#KLIČNO ŠTEVILO

def klicno_stevilo(G):
    g = G.complement()
    n=g.order()
    p = MixedIntegerLinearProgram(maximization = True)
    x = p.new_variable(binary = True)
    p.set_objective(sum([x[i] for i in range(n)]))
    for u,v in g.edges(labels=False):
        p.add_constraint(x[u] + x[v] <=1)
    res2 = p.get_values(x)
    return p.solve()

#DELJENO KROMATIČNO IN KLIČNO ŠTEVILO

def deljeno_kromaticno_stevilo(G, mnozice=None):
    if mnozice is None:
        mnozice = maksimalne_neodvisne_mnozice(G)
    m = len(mnozice)
    n = G.order()
    p = MixedIntegerLinearProgram(maximization = False)
    y = p.new_variable(real=True, nonnegative=True)
    p.set_objective(sum([y[i] for i in range(m)]))
    for v in G:
        p.add_constraint(sum(y[i] for i in range(m) if v in mnozice[i]) >= 1)

    return p.solve()

def deljeno_klicno_stevilo(G, mnozice=None):
    if mnozice is None:
        mnozice = maksimalne_neodvisne_mnozice(G)
    m = len(mnozice)
    n = G.order()
    p = MixedIntegerLinearProgram(maximization = True)
    y = p.new_variable(real=True, nonnegative=True)
    p.set_objective(sum([y[v] for v in G]))
    for i in range(m):
        p.add_constraint(sum(y[v] for v in mnozice[i]) <= 1)

    return p.solve()




# preizkus na Kneserjevem (5,2) grafu
G = graphs.KneserGraph(5,2)
G.relabel()
mnozice = maksimalne_neodvisne_mnozice(G)
kromaticno_stevilo(G)
klicno_stevilo(G)
deljeno_kromaticno_stevilo(G, mnozice)
deljeno_klicno_stevilo(G, mnozice)


#preizkus na kubičnem grafu
H = graphs.CubeGraph(4)
H.relabel()
mnozice = maksimalne_neodvisne_mnozice(H)
kromaticno_stevilo(H)
klicno_stevilo(H)
deljeno_kromaticno_stevilo(H, mnozice)
deljeno_klicno_stevilo(H, mnozice)

#preizkus na krožnem grafu s 13 vozlišči
K = graphs.CirculantGraph(13,2)
K.relabel()
mnozice = maksimalne_neodvisne_mnozice(K)
kromaticno_stevilo(K)
klicno_stevilo(K)
deljeno_kromaticno_stevilo(K, mnozice)
deljeno_klicno_stevilo(K, mnozice)
︡573ec7f4-a587-411e-9049-397140d9d5cf︡{"stdout":"3.0"}︡{"stdout":"\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.5\n"}︡{"stdout":"2.5000000000045\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.0000000000135008\n"}︡{"stdout":"3.0"}︡{"stdout":"\n"}︡{"stdout":"2.0\n"}︡{"stdout":"2.166666666666667\n"}︡{"stdout":"2.1666666666764454\n"}︡{"done":true}︡









