#pagebreak(to:"odd")

#import "../config/glossario-data.typ": gls

= Progettazione

L'obiettivo della fase di progettazione è stato delineare la struttura di un sistema in grado di rispettare i requisiti derivati dalla fase di studio del dominio.
La fase iniziale è stata dedicata alla strutturazione del backend, costruendo i diagrammi delle classi per modellare le principali entità del sistema. A questa fase è stata data particolare attenzione poichè è il backend che contiene tutta la logica del sistema, il recupero dati e il motore di classificazione delle vulnerabilità, delegando al frontend solo la parte di interfaccia.
Successivamente è stato strutturato il frontend, ricercando quali fossero i pattern più usati nel framework di Angular per strutturare correttamente un'interfaccia web.

== Architettura di backend

Il backend è stato modellato con un'architettura esagonale. Questo tipo di struttura ha come obiettivo primario isolare la logica di business, garantendo un'elevata testabilità e indipendenza da tecnologie esterne. Il #emph([#gls("core")]) in questo modo risulta completamente agnostico rispetto ai dettagli implementativi di framework, database o provider di dati esterni.
Il sistema è strutturato in livelli concentrici:

- #emph("Domain"): rappresenta il nucleo dell'architettura, contiene le entità (modellate tramite classi) sulle quali si basa tutto il sistema ed è privo di dipendenze esterne.

- #emph("Services"): definiscono i casi d'uso dell'applicazione e fungono da orchestratori. Hanno il compito di implementare le #emph("Inbound Ports") per gestire le richieste in ingresso, coordinano gli oggetti del dominio e utilizzano le #emph("Outbound Ports") per delegare all'esterno operazioni come salvataggio o recupero di dati.

- #emph("Ports"): sono il punto di connessione tra il dominio e l'esterno, permettendo una comunicazione strutturata senza creare accoppiamento. Si suddividono in Inbound Ports (definiscono i casi d'uso accessibili dall'esterno) e Outbound Ports (modellano interfacce per dialogare con l'esterno)

- #emph("Adapters"): rappresentano lo strato più esterno e operando come traduttori tra le tecnologie specifiche ed il nucleo. Si suddividono in #emph("Inbound Adapters") (guidano l'input invocando le #emph("Inbound Ports")) e #emph("Outbound Adapters") (vengono guidati dall'applicazione per interagire con l'infrastruttura esterna tramite le #emph("Outbound Ports")).

=== Diagramma delle classi di backend
\
\

#pad(x: -2.5cm)[
  #figure(
    image("/images/AssessmentDiagram.png", width: 100%),
    caption: [Diagramma architetturale dei componenti]
  )
]
\ 
\
Il diagramma raffigura la modellazione principale delle componenti di backend.
\
\
L'inbound adapter