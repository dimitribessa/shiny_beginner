 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".testetree");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
  
  var $el = $(el);
  
  //ajustando os dados aos parâmetros do gráfico (01-fev-2019)
  var teste = data;
 /* Object.keys(teste).forEach(function(key) {
  teste[key].unshift(key);
});
  
  var result = Object.keys(teste).map(function(key) {
  return teste[key];
});
  //console.log(result[1]);
 //para as categorias do eixo x
  var nome_x = teste['.id'];
 // nome_x = [nome_x[0],nome_x[1],nome_x[3],nome_x[2],nome_x[4]];
  nome_x.shift();
  result.shift();

  //console.log(nome_x);

*/
 console.log(teste);
 Highcharts.chart('container', {
        series: [{
            type: 'treemap',
            layoutAlgorithm: 'squarified',
            allowDrillToNode: true,
            animationLimit: 1000,
            dataLabels: {
                enabled: false
            },
            levelIsConstant: false,
            levels: [{
                level: 1,
                dataLabels: {
                    enabled: true
                },
                borderWidth: 3
            }],
            data: teste
        }],
        subtitle: {
            text: 'Click points to drill down. Source: <a href="http://apps.who.int/gho/data/node.main.12?lang=en">WHO</a>.'
        },
        title: {
            text: 'Global Mortality Rate 2012, per 100 000 population'
        };
      });
};

// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shiny.tree");