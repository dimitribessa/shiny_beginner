 // This isn't strictly necessary, but it's good JavaScript hygiene.
//(function() {

var binding = new Shiny.OutputBinding();

binding.find = function(scope) {
  // For the given scope, return the set of elements that belong to
  // this binding.
  return $(scope).find(".barcanvas");
};

binding.renderValue = function(el, data) {
  // This function will be called every time we receive new output
  // values for a line chart from Shiny. The "el" argument is the
  // div for this particular chart.
 /* 
  var $el = $(el);
  
  //ajustando os dados aos parâmetros do gráfico (01-fev-2019)
  var teste = data;
  Object.keys(teste).forEach(function(key) {
  teste[key].unshift(key);
});
  
  var result = Object.keys(teste).map(function(key) {
  return teste[key];
});

 //para as categorias do eixo x
  var nome_x = teste['.id'];
  nome_x.shift();

  //console.log(nome_x);*/
/*
 var empty = Array();
 for(i = 0, i = result.length)
 
  var x = [
            ['data1', 30, 200, 100, 400, 150, 250],
            ['data2', 130, 100, 140, 200, 150, 50]
        ];
  console.log(x);*/

 /*These lines are all chart setup.  Pick and choose which chart features you want to utilize. */
 var chart = new CanvasJS.Chart(el, {
  animationEnabled: true,
  exportEnabled: true,
  
  axisX: {
    valueFormatString: "MMM"
  },
  axisY: {
    includeZero: false,
    suffix: " °C"
  },
  toolTip: {
    shared: true
  },
  legend: {
    cursor: "pointer",
    itemclick: toggleDataSeries
  },

  data: [{
    type: "rangeColumn",
    name: "City 1",
    showInLegend: true,
    yValueFormatString: "#0.## °C",
    xValueFormatString: "MMM, YYYY",
    dataPoints: [   
      { x: new Date(2016, 00), y: [08, 20] },
      { x: new Date(2016, 01), y: [10, 24] },
      { x: new Date(2016, 02), y: [16, 29] },
      { x: new Date(2016, 03), y: [21, 36] },
      { x: new Date(2016, 04), y: [26, 39] },
      { x: new Date(2016, 05), y: [22, 39] },
      { x: new Date(2016, 06), y: [20, 35] },
      { x: new Date(2016, 07), y: [20, 34] },
      { x: new Date(2016, 08), y: [20, 34] },
      { x: new Date(2016, 09), y: [19, 33] },
      { x: new Date(2016, 10), y: [13, 28] },
      { x: new Date(2016, 11), y: [09, 23] }
    ]
    },
    {
      type: "rangeColumn",
      name: "City 2",
      showInLegend: true,
      yValueFormatString: "#0.## °C",
      xValueFormatString: "MMM, YYYY",
      dataPoints: [   
        { x: new Date(2016, 00), y: [16, 28] },
        { x: new Date(2016, 01), y: [18, 31] },
        { x: new Date(2016, 02), y: [20, 33] },
        { x: new Date(2016, 03), y: [22, 34] },
        { x: new Date(2016, 04), y: [22, 33] },
        { x: new Date(2016, 05), y: [20, 29] },
        { x: new Date(2016, 06), y: [20, 28] },
        { x: new Date(2016, 07), y: [20, 28] },
        { x: new Date(2016, 08), y: [20, 28] },
        { x: new Date(2016, 09), y: [20, 28] },
        { x: new Date(2016, 10), y: [14, 27] },
        { x: new Date(2016, 11), y: [11, 26] }
      ]
  }]

 });
 chart.render();

 function toggleDataSeries(e) {
  if (typeof (e.dataSeries.visible) === "undefined" || e.dataSeries.visible) {
    e.dataSeries.visible = false;
  } else {
    e.dataSeries.visible = true;
  }
  e.chart.render();
 }
 /*console.log(binding);*/
}

// Tell Shiny about our new output binding
Shiny.outputBindings.register(binding, "shinyjs.barcanvas");
//}) //endfunction

