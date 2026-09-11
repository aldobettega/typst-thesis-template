#import "../config/glossario-data.typ": gls

#pagebreak()

= Implementazione e Scelte Tecnologiche

== Modellazione e Validazione dei Dati

Avendo scelto un'architettura di tipo esagonale e #gls("fastapi") come framework per il #gls("backend"), è stato necessario scegliere in quale punto del sistema utilizzare #gls("pydantic") (libreria per la validazione dati spesso usata, poiché integrata nativamente, con #gls("fastapi")).
Consultando diversi forum di #emph("developers"), è emerso che inserire #gls("pydantic") in un'architettura esagonale è un problema concreto che anima diverse discussioni. 
Le due scelte plausibili sono:

+ creare nel dominio delle classi #gls("pydantic")
+ mantenere #gls("pydantic") all'esterno del dominio, costruendolo con le #emph("dataclasses") di #gls("python")

Gli argomenti a sostegno della prima tesi sono una minore quantità di codice #emph("boilerplate"), evitando duplicazioni inutili e mappature di dati che aggiungono logica non necessaria al funzionamento del programma, allungando il lavoro del programmatore.
Tuttavia, la seconda tesi è maggiormente supportata da gran parte della letteratura architetturale.
In primo luogo, introdurre una libreria esterna come #gls("pydantic") nel dominio violerebbe il principio dell'architettura esagonale o della #emph("clean architecture"), come riportato dalla letteratura @clean. In secondo luogo, la validazione dei dati deve avvenire ai confini del sistema: nel nostro caso validiamo i dati in entrata e in uscita nel layer dell'Inbound Adapter.
Dunque, la soluzione è stata scrivere delle funzioni di mappatura a livello dell'Inbound Adapter, in modo che i dati vengano validati e serializzati in un oggetto #gls("pydantic") che possa rispettare le richieste del contratto dell'#gls("api"). In questo modo, oltre che validare, è possibile mantenere la logica di dominio stabile e lasciare eventuali modifiche al livello di mappatura dell'oggetto, adattandolo alle esigenze delle #gls("api").

== Persistenza dei dati nell'#gls("mvp")

Nell'MVP (#emph("Minimum Viable Product")) è stato deciso di mantenere una persistenza dati volatile, senza implementare un rigoroso #emph("database"). L'adattatore esterno `InMemoryAnalysisStore` gestisce autonomamente la persistenza e recupero degli oggetti tramite semplici metodi `get` e `save` che simulano un #emph("database") salvandoli in un dizionario. Tuttavia, in questo modo gli oggetti alla distruzione dell'istanza della classe (ad esempio quando il container dell'app viene ricostruito), vengono dimenticati e non è più possibile recuperarli.
Questa scelta è stata fatta per semplificare e velocizzare lo sviluppo, considerando che i requisiti dell'attuale prototipo non rendono strettamente necessaria l'integrazione di un sistema completo per la gestione di basi di dati.
Ad ogni modo, grazie alla modularità dell'architettura esagonale, una futura transizione verso una soluzione di persistenza stabile risulterebbe un'operazione semplice. Per integrare un #emph("database") sarà sufficiente sviluppare un nuovo #emph("Outbound Adapter") che concretizzi i metodi già definiti dalle interfacce delle porte dedicate. Questo approccio assicura che il nuovo innesto non alteri altre parti della piattaforma, come la logica interna di #gls("backend") o la parte di interfaccia di #gls("frontend").

== Sicurezza e comunicazione HTTP

L'architettura del sistema prevede una rigorosa segregazione tra il livello di presentazione (Angular, servito sulla porta `4200`) e il livello applicativo (FastAPI, esposto sulla porta `8000`). Anche se questa separazione garantisce un'elevata modularità e prevenga l'esposizione di informazioni sensibili lato client, introduce un vincolo nella comunicazione diretta a causa della #emph[Same-Origin Policy] (SOP). 

La SOP è una regola di sicurezza implementata dai browser che impedisce agli script eseguiti in una specifica "origine" (formata dalla combinazione di protocollo, dominio e porta) di leggere dati provenienti da un'origine differente. Nel nostro caso le origini di frontend e backend differiscono nella porta, per questo si attiva tale regola di sicurezza, bloccando di default le richieste dirette dal #gls("frontend") al #gls("backend").

Per comunicare al sistema che questa origine differente risulta sicura, occorre implementare il protocollo #emph("Cross-Origin Resource Sharing") (CORS). In #gls("fastapi") la gestione del CORS viene condotta dal #emph("Middleware"), una copertura esterna attraverso la quale passa ogni richiesta al server.
\ \
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:4200"], 
    allow_credentials=True,
    allow_methods=["*"], 
    allow_headers=["*"], 
)
```
\ \
In questo, il server è configurato per consentire l'origine differente del frontend (`http://localhost:4200`), consentendo qualsiasi metodo e qualsiasi header.
Questo funziona perché quando #gls("angular") con #emph("HttpClient") effettua una richiesta verso #gls("fastapi"), il browser esegue prima una *#emph("Preflight Request")* di questo tipo:
\ \
```
OPTIONS /api/test-connessione HTTP/1.1
Host: 127.0.0.1:8000
Origin: http://localhost:4200
Access-Control-Request-Method: GET
```
\ \
chiedendo al server se autorizza questa chiamata. Grazie al #emph("Middleware") il server è configurato per accettarla, dunque non riceve un messaggio di errore e viene effettuata la richiesta, rispondendo al #emph("Preflight") con una risposta tipo:
\ \
```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: http://localhost:4200
Access-Control-Allow-Methods: GET, POST, OPTIONS
```
\ \

== Richieste #gls("api") Batch

Una sfida implementativa è stata doversi scontrare con i limiti imposti dalle #gls("api") di tecnologie esterne, in particolare i data providers e il modello gratuito di Gemini.
Infatti, non è possibile, per limiti infrastrutturali di queste tencologie, richiedere con una sola chiamata #gls("api") dati o informazioni per centinaia di #gls("cve") senza incorrere in un #emph[#gls("rate-limit")].
Per risolvere questa problematica è stato necessario dividere il payload totale di #gls("cve") in batch la cui dimensione non raggiungesse il #emph[#gls("rate-limit")] imposto dalla specifica #gls("api"). In certi casi, tra una chiamata di rete e l'altra è anche stato necessario introdurre un ritardo programmato per distanziarle temporaneamente, sempre per rispettare i limiti imposti dalle tecnologie esterne.
Questa logica è stata confinata al livello degli #emph("Outbound Adapters"), rivelando ancora una volta i vantaggi di modularità dell'architettura esagonale e di isolamento del dominio rispetto alle tecnologie esterne.