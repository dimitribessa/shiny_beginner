<div align="center">
<h1> Shiny Apps (My repository - beginner level) </h1>
</div>

This repository contains some of my older projects (made between 2017-2021). I decided to share them because i believe that some line of code in these scripts may help someone solve their issues (a lot of peaple helped me sharing codes, so i really hope to contribute in some way).

All the projects described here are running on my personal server (thanks to Dean Attali for the
tutorial on how configure the shiny-server, available [here](https://deanattali.com/2015/05/09/setup-rstudio-shiny-server-digital-ocean/). This really changes lifes!!).

ps. I´m a brazilian guy, so portuguese language was used on the projects (also in the comments lines).

## Why "beginner level"?

The applications described here were primarily developed to learn Shiny, along with some HTML5, CSS, and JavaScript. 
As a result, certain aspects were not taken into consideration, such as:

- Code organization and cleaning;
- DRY concept (Don´t Repeat Yourself) was not applied;
- Perfomance was not considered;
- Many "TODO" features still remains;
- A lot of bugs to fix;
- Some lines of codes are too long and the codes doesn't follow the best organization practices;
- Modules were not used;
- Some applications take too long to load (because large databases, or innefective functions, or redundant libraries...);
- Most of Applications are with basics layouts and simple features.

Regarding the UI, i've applied the default methods in some applications, making use of the assembled shiny functions. But as far as was learning HTML/CSS and JavaScript, i've structured the apps using _tags_ for head, header and body, and always inserting some CSS and JS codes when it was possible.

Then, In the terms of JavaScript widgets, inspired by Joe Cheng output binding ([here](https://github.com/rstudio/shiny-examples/tree/main/054-nvd3-line-chart-output)), now i always write my own scripts to use some JS graph library (hicharts, Echarts, Apexcharts, canvasJS, and so on...).

## Organization of this repository

Follows the manner how this page is structured

```
projectName/
├── README.md
├── www/
│   ├── *.js
│   ├── *.css
│   └── some other folders and files
├── tidying data
│   ├── *.R
│   └── some database file
├── *.RData
├── ui.R
├── server.R
└── other files (*.R)
```

All the projects folder holds the classic Shiny App structure (with a www folder, ui.R and server.R files), followed by a brief description in a README file, and sometimes a folder named "tidying data" - 
that contains a script (and occasionally a database) used to arrange the data that the application utilizes (*.RData file). Sometimes
 support scripts may be used.

## Projects

Here is the list of all project applications available here and hosted on my personal server

- [Eleições 2018 (Elections results 2018)](http://142.93.67.223/shiny/eleic2018);
- [Encarcerados (DEPEN) (Prison population)](http://142.93.67.223/shiny/encarcerado_simate/);
- [Equipamentos Hospitalares SUS (Hospital Equipment from SUS)](http://142.93.67.223/shiny/equipsaude/);
- [Exportação / Importação (Exports / Imports)](http://142.93.67.223/shiny/expo_prototipo);
- [Exportação e redes de Insumos (Exports and input network)](http://142.93.67.223/shiny/expo_prototipo);
- ["Gerador de Impacto"](http://142.93.67.223/shiny/impactomatriz/);
- [Desenvolvimento Humano e Vulnerabilidade Social (Human Development and Social vulnerability indicators)](http://142.93.67.223/shiny/planejterrit/);
- [Empresas e ICMS](http://142.93.67.223/shiny/V8/);
- [Violência Doméstica (Domestic Violence)](http://142.93.67.223/shiny/violencia/);
- [Consumption and Wages](http://142.93.67.223/shiny/pof_rais);
- [Historical temperatures in Santa Catarina state](http://142.93.67.223/shiny/mediatemp1);
- [COVID-19 in Santa Catarina state](http://142.93.67.223/shiny/covidSC/);
- [Climate projections](http://142.93.67.223/shiny/mud_climatica/);








