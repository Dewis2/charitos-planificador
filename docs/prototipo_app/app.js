const routes = [
  { id: "inicio", title: "Inicio", icon: "⌂" },
  { id: "productos", title: "Productos", icon: "◇" },
  { id: "stock", title: "Registrar stock", icon: "▣" },
  { id: "produccion", title: "Registrar producción", icon: "♨" },
  { id: "ventas", title: "Registrar ventas", icon: "▤" },
  { id: "merma", title: "Registrar merma", icon: "♲" },
  { id: "pedidos", title: "Pedidos confirmados", icon: "✓" },
  { id: "lotes", title: "Lotes y vencimientos", icon: "◷" },
  { id: "recomendacion", title: "Recomendación", icon: "↗" },
  { id: "reportes", title: "Reportes", icon: "▥" },
  { id: "csv", title: "Importar / Exportar", icon: "⇅" },
  { id: "configuracion", title: "Configuración", icon: "⚙" },
];

const products = [
  { name: "Vainilla - Mármol", category: "vainilla", price: 35, stock: 2 },
  { name: "3 Leches - Fresa", category: "3 leches", price: 45, stock: 3 },
  { name: "Selva Negra - Oreo", category: "selva negra", price: 45, stock: 1 },
  { name: "Helada - Mediana", category: "helada", price: 25, stock: 2 },
  { name: "Pasteles - Cachito", category: "pasteles", price: 2, stock: 14 },
  { name: "Pasteles - Mil hojas", category: "pasteles", price: 3, stock: 9 },
  { name: "Bocaditos Jacki", category: "bocadito", price: 35, stock: 1 },
];

const state = {
  route: "inicio",
  productSearch: "",
  productCategory: "todas",
};

const screen = document.querySelector("#screen");
const screenTitle = document.querySelector("#screenTitle");
const drawer = document.querySelector("#drawer");
const drawerNav = document.querySelector("#drawerNav");
const scrim = document.querySelector("#scrim");
const modalBackdrop = document.querySelector("#modalBackdrop");
const modal = document.querySelector("#modal");
const toast = document.querySelector("#toast");

const money = (value) => `S/ ${Number(value).toFixed(2)}`;
const initial = (name) => name.trim().charAt(0).toUpperCase();

function heading(title, subtitle) {
  return `<div class="page-heading"><h3>${title}</h3><p>${subtitle}</p></div>`;
}

function metric(label, value, icon, alert = false) {
  return `<article class="card metric-card ${alert ? "alert" : ""}">
    <span class="metric-icon">${icon}</span><span class="metric-value">${value}</span><span class="metric-label">${label}</span>
  </article>`;
}

function info(text, tone = "") {
  return `<div class="card info-card ${tone}"><span class="info-icon">ⓘ</span><span>${text}</span></div>`;
}

function field(label, type = "text", value = "", options = "") {
  if (type === "select") {
    return `<div class="field"><label>${label}</label><select>${options}</select></div>`;
  }
  if (type === "textarea") {
    return `<div class="field"><label>${label}</label><textarea placeholder="${value}"></textarea></div>`;
  }
  return `<div class="field"><label>${label}</label><input type="${type}" value="${value}" /></div>`;
}

function renderDashboard() {
  const production = [160, 172, 148, 181, 190, 205, 178];
  const sales = [151, 169, 143, 176, 187, 198, 172];
  const days = ["19", "20", "21", "22", "23", "24", "25"];
  const bars = days.map((day, index) => `<div class="bar-day">
    <i class="bar" style="height:${production[index] / 2.15}px"></i>
    <i class="bar alt" style="height:${sales[index] / 2.15}px"></i><small>${day}</small>
  </div>`).join("");

  return `${heading("Resumen de hoy", "Indicadores calculados con los datos guardados en este dispositivo.")}
    <div class="metric-grid">
      ${metric("Productos activos", "48", "✓")}
      ${metric("Ventas del día", "172", "▤")}
      ${metric("Producción recomendada", "165", "↗")}
      ${metric("Producción registrada", "178", "♨")}
      ${metric("Merma del día", "3", "♲", true)}
      ${metric("Costo de merma", "S/ 32.55", "S/", true)}
      ${metric("Por vencer", "5", "!", true)}
      ${metric("Vencidos", "1", "×", true)}
    </div>
    <h4 class="section-title">Producción vs ventas · últimos 7 días</h4>
    <article class="card chart-card"><div class="bar-chart">${bars}</div>
      <div class="chart-legend"><span><i class="dot"></i>Producción</span><span><i class="dot teal"></i>Ventas</span></div>
    </article>
    <h4 class="section-title">Productos con mayor merma</h4>
    <div class="list">
      ${["Pasteles - Cachito", "3 Leches - Fresa", "Vainilla - Pequeña"].map((name, index) => `<article class="card list-card"><span class="avatar">${initial(name)}</span><div><strong>${name}</strong><small>Últimos 30 días</small></div><span class="price">${[18, 9, 7][index]} u.</span></article>`).join("")}
    </div>`;
}

function renderProducts() {
  const categories = ["todas", ...new Set(products.map((item) => item.category))];
  const filtered = products.filter((item) =>
    item.name.toLowerCase().includes(state.productSearch.toLowerCase()) &&
    (state.productCategory === "todas" || item.category === state.productCategory));
  return `${heading("Catálogo de productos", "Administre precios, vida útil y parámetros de producción.")}
    <div class="search-row">
      <input class="search-input" id="productSearch" value="${state.productSearch}" placeholder="Buscar producto" />
      <select class="filter-select" id="productCategory">${categories.map((category) => `<option value="${category}" ${state.productCategory === category ? "selected" : ""}>${category}</option>`).join("")}</select>
    </div>
    <div class="list">${filtered.length ? filtered.map((item) => `<article class="card list-card">
      <span class="avatar">${initial(item.name)}</span><div><strong>${item.name}</strong><small>${item.category} · unidad · vida útil ${item.category === "pasteles" ? 2 : 4} días<br>Stock actual: ${item.stock}</small></div><div class="price">${money(item.price)}<small>⋮</small></div>
    </article>`).join("") : `<div class="card empty"><b>Sin coincidencias</b>Pruebe con otro nombre o categoría.</div>`}</div>
    <button class="button fab" data-action="new-product">＋ Nuevo producto</button>`;
}

const transactionConfig = {
  stock: {
    title: "Registrar stock",
    subtitle: "Capture el conteo y los movimientos del cierre diario.",
    fields: () => `${field("Producto *", "select", "", productOptions())}${field("Fecha *", "date", "2026-06-25")}${field("Ubicación *", "select", "", locationOptions())}
      <div class="field-row">${field("Stock inicial *", "number", "18")}${field("Stock final *", "number", "12")}</div>
      <div class="field-row">${field("Producido para vitrina *", "number", "8")}${field("Transferencia recibida *", "number", "0")}</div>${field("Transferencia enviada *", "number", "0")}`,
    message: "Stock registrado en el prototipo",
  },
  produccion: {
    title: "Registrar producción",
    subtitle: "La vida útil del producto determina el vencimiento del lote.",
    fields: () => `${field("Producto *", "select", "", productOptions())}${field("Fecha *", "date", "2026-06-25")}${field("Cantidad producida *", "number", "8")}${field("Ubicación destino *", "select", "", locationOptions())}`,
    message: "Producción y lote registrados en el prototipo",
  },
  ventas: {
    title: "Registrar venta",
    subtitle: "La salida consume primero los lotes próximos a vencer (FEFO).",
    fields: () => `${field("Producto *", "select", "", productOptions())}${field("Fecha *", "date", "2026-06-25")}${field("Ubicación *", "select", "", locationOptions())}<div class="field-row">${field("Cantidad vendida *", "number", "3")}${field("Precio unitario *", "number", "35.00")}</div>` ,
    message: "Venta registrada y stock actualizado",
  },
  merma: {
    title: "Registrar merma",
    subtitle: "Registre cantidad, causa y costo para medir la pérdida económica.",
    fields: () => `${field("Producto *", "select", "", productOptions())}${field("Fecha *", "date", "2026-06-25")}${field("Ubicación *", "select", "", locationOptions())}<div class="field-row">${field("Cantidad de merma *", "number", "1")}${field("Costo unitario *", "number", "16.45")}</div>${field("Motivo de merma *", "select", "", `<option>no_vendido</option><option>vencido</option><option>calidad</option><option>dañado</option>`)}`,
    message: "Merma registrada; costo estimado S/ 16.45",
  },
};

function productOptions() {
  return products.slice(0, 6).map((item) => `<option>${item.name}</option>`).join("");
}

function locationOptions() {
  return `<option>general</option><option>tienda_1</option><option>tienda_2</option><option>taller</option>`;
}

function renderTransaction(type) {
  const config = transactionConfig[type];
  return `${heading(config.title, config.subtitle)}
    <form class="card form-card" onsubmit="return false">${config.fields()}${field("Observación", "textarea", "Detalle opcional del movimiento")}
      <button class="button block" data-action="save-transaction" data-message="${config.message}">✓ Guardar registro</button>
    </form>`;
}

function renderOrders() {
  const rows = [
    ["3 Leches - Fresa", "Ana Torres", "25 jun", "1", "S/ 45.00"],
    ["Vainilla - 2 Pisos", "Carlos Huamán", "25 jun", "1", "S/ 40.00"],
    ["Bocaditos Jacki", "María Quispe", "25 jun", "2", "S/ 70.00"],
    ["Selva Negra - Oreo", "José Rojas", "27 jun", "1", "S/ 45.00"],
  ];
  return `${heading("Pedidos confirmados", "Demanda segura administrada por separado de las ventas de vitrina.")}
    ${info("Los pedidos se suman al total operativo, pero no cambian la recomendación de vitrina.", "teal")}
    <div class="list">${rows.map((row) => `<article class="card list-card"><span class="avatar">${initial(row[0])}</span><div><strong>${row[0]}</strong><small>${row[1]} · entrega ${row[2]} · ${row[3]} unidad</small><span class="status-badge">confirmado</span></div><span class="price">${row[4]}</span></article>`).join("")}</div>
    <button class="button fab" data-action="new-order">＋ Registrar pedido</button>`;
}

function renderLots() {
  const lots = [
    ["Pasteles - Cachito", "12", "26/06/2026", "1 día", "warning"],
    ["3 Leches - Fresa", "3", "27/06/2026", "2 días", "warning"],
    ["Vainilla - Mármol", "2", "28/06/2026", "3 días", ""],
    ["Selva Negra - Oreo", "1", "25/06/2026", "Vencido", "warning"],
    ["Helada - Mediana", "2", "29/06/2026", "4 días", ""],
  ];
  return `${heading("Lotes y vencimientos", "Controle el saldo disponible según la vida útil de cada producción.")}
    <div class="segmented"><button class="active">Todos</button><button>Por vencer</button><button>Vencidos</button></div>
    <div class="list">${lots.map((row) => `<article class="card list-card"><span class="avatar">◷</span><div><strong>${row[0]}</strong><small>${row[1]} unidades · vence ${row[2]}</small></div><span class="status-badge ${row[4]}">${row[3]}</span></article>`).join("")}</div>`;
}

function recommendationCard(name, category, recommendation, demand, stock, orders) {
  const total = recommendation + orders;
  return `<article class="card recommend-card"><button class="recommend-head" data-action="toggle-recommendation"><span class="avatar">${initial(name)}</span><span><strong>${name}</strong><small>${category} · promedio ponderado de ventas</small></span><span class="recommend-number">${recommendation}<small>vitrina</small></span></button>
    <div class="recommend-detail">
      <div class="detail-row"><span>Demanda estimada</span><strong>${demand.toFixed(1)}</strong></div>
      <div class="detail-row"><span>Stock vendible</span><strong>${stock.toFixed(1)}</strong></div>
      <div class="detail-row"><span>Stock de seguridad</span><strong>2.0</strong></div>
      <div class="detail-row"><span>Producción ya registrada</span><strong>0.0</strong></div>
      <div class="detail-row"><span>Ajuste por merma</span><strong>0.4</strong></div>
      <div class="detail-row total"><span>Producción recomendada para vitrina</span><strong>${recommendation.toFixed(1)}</strong></div>
      <div class="detail-row total"><span>Pedidos confirmados</span><strong>${orders.toFixed(1)}</strong></div>
      <div class="detail-row total"><span>Total operativo</span><strong>${total.toFixed(1)}</strong></div>
    </div></article>`;
}

function renderRecommendations() {
  return `${heading("Plan de producción", "Recomendación explicable para la fecha actual.")}
    ${info("La recomendación usa solo ventas de vitrina. Los pedidos se muestran separados y se suman únicamente al total operativo.")}
    <div class="list">
      ${recommendationCard("Vainilla - Mármol", "vainilla", 3, 2.8, 2, 1)}
      ${recommendationCard("3 Leches - Fresa", "3 leches", 4, 4.2, 2, 1)}
      ${recommendationCard("Pasteles - Cachito", "pasteles", 15, 16.6, 4, 0)}
      ${recommendationCard("Selva Negra - Oreo", "selva negra", 3, 3.4, 1, 1)}
    </div>
    <button class="button block" data-action="prototype-toast" data-message="Recomendaciones preparadas para exportar">⇧ Exportar recomendaciones CSV</button>`;
}

function renderReports() {
  const waste = [["Pasteles - Cachito", 100, "18 u."], ["3 Leches - Fresa", 62, "9 u."], ["Vainilla - Pequeña", 48, "7 u."], ["Selva Negra - Oreo", 34, "5 u."]];
  const categories = [["pasteles", 100, "S/ 186"], ["vainilla", 55, "S/ 142"], ["3 leches", 46, "S/ 128"], ["selva negra", 35, "S/ 96"]];
  const progress = (rows, tone = "") => rows.map((row) => `<div class="progress-item"><div class="progress-label"><span>${row[0]}</span><strong>${row[2]}</strong></div><div class="progress-track ${tone}"><i style="width:${row[1]}%"></i></div></div>`).join("");
  return `${heading("Reportes", "Indicadores consolidados para revisar producción y merma.")}
    <h4 class="section-title">Merma por producto</h4><article class="card form-card">${progress(waste)}</article>
    <h4 class="section-title">Costo de merma por categoría</h4><article class="card form-card">${progress(categories, "teal")}</article>
    <h4 class="section-title">Riesgo de vencimiento</h4><article class="card list-card"><span class="avatar">!</span><div><strong>5 productos por vencer</strong><small>Revise lotes dentro de los próximos 2 días</small></div><span class="chevron">›</span></article>`;
}

function renderCsv() {
  const modules = ["Productos", "Stock histórico", "Producción", "Ventas de vitrina", "Merma", "Pedidos confirmados"];
  return `${heading("Intercambio de datos", "Archivos CSV UTF-8 con validación por fila.")}
    ${info("Importe productos antes que los movimientos históricos para conservar las referencias.", "teal")}
    <h4 class="section-title">Importar CSV</h4><div class="list">${modules.map((name) => `<article class="card io-card" data-action="prototype-toast" data-message="Selector de archivo abierto para ${name}"><span class="io-icon">⇧</span><span><strong>${name}</strong><small>Seleccionar y validar archivo</small></span><span class="chevron">›</span></article>`).join("")}</div>
    <h4 class="section-title">Exportar CSV</h4><div class="list">${modules.map((name) => `<article class="card io-card" data-action="prototype-toast" data-message="${name}: archivo preparado para compartir"><span class="io-icon">⇩</span><span><strong>${name}</strong><small>Crear y compartir archivo</small></span><span class="chevron">›</span></article>`).join("")}</div>`;
}

function renderSettings() {
  return `${heading("Parámetros internos", "Estos valores afectan cálculos y alertas del dispositivo.")}
    <form class="card form-card" onsubmit="return false">
      ${field("Factor de ajuste por merma", "number", "0.5")}${field("Días de análisis histórico", "number", "30")}
      <div class="field-row">${field("Moneda", "text", "S/")}${field("Umbral por vencer (días)", "number", "2")}</div>
      ${field("Ubicación predeterminada", "select", "", locationOptions())}
      ${switchRow("Redondear por lote", "Respeta lote mínimo y múltiplo", true)}
      ${switchRow("Alertas de stock vencido", "Mostrar en dashboard y lotes", true)}
      ${switchRow("Alertas de stock por vencer", "Usa el umbral configurado", true)}
      <button class="button block" data-action="prototype-toast" data-message="Configuración guardada en el prototipo">✓ Guardar configuración</button>
    </form>`;
}

function switchRow(title, subtitle, on) {
  return `<div class="switch-row"><span><strong>${title}</strong><small>${subtitle}</small></span><button class="switch ${on ? "on" : ""}" data-action="toggle-switch" aria-label="${title}"></button></div>`;
}

function renderRoute() {
  const route = routes.find((item) => item.id === state.route) || routes[0];
  screenTitle.textContent = route.title;
  const renderers = {
    inicio: renderDashboard,
    productos: renderProducts,
    stock: () => renderTransaction("stock"),
    produccion: () => renderTransaction("produccion"),
    ventas: () => renderTransaction("ventas"),
    merma: () => renderTransaction("merma"),
    pedidos: renderOrders,
    lotes: renderLots,
    recomendacion: renderRecommendations,
    reportes: renderReports,
    csv: renderCsv,
    configuracion: renderSettings,
  };
  screen.innerHTML = renderers[route.id]();
  screen.scrollTop = 0;
  syncNavigation();
}

function syncNavigation() {
  drawerNav.querySelectorAll("button").forEach((button) => button.classList.toggle("active", button.dataset.route === state.route));
  document.querySelectorAll(".bottom-nav [data-route]").forEach((button) => button.classList.toggle("active", button.dataset.route === state.route));
}

function navigate(route) {
  if (!routes.some((item) => item.id === route)) route = "inicio";
  state.route = route;
  if (location.hash !== `#${route}`) history.replaceState(null, "", `#${route}`);
  closeDrawer();
  renderRoute();
}

function openDrawer() {
  drawer.classList.add("open");
  scrim.classList.add("open");
}
function closeDrawer() {
  drawer.classList.remove("open");
  scrim.classList.remove("open");
}

function openModal(content) {
  modal.innerHTML = content;
  modalBackdrop.classList.add("open");
  modalBackdrop.setAttribute("aria-hidden", "false");
}
function closeModal() {
  modalBackdrop.classList.remove("open");
  modalBackdrop.setAttribute("aria-hidden", "true");
}

let toastTimer;
function showToast(message) {
  toast.textContent = message;
  toast.classList.add("show");
  clearTimeout(toastTimer);
  toastTimer = setTimeout(() => toast.classList.remove("show"), 2200);
}

function productModal() {
  return `<h3>Nuevo producto</h3><p>Configure la información comercial y productiva.</p>
    ${field("Nombre *", "text", "Torta de temporada")}
    <div class="field-row">${field("Categoría", "select", "", `<option>vainilla</option><option>3 leches</option><option>pasteles</option><option>otro</option>`)}${field("Unidad", "select", "", `<option>unidad</option><option>caja</option><option>kg</option>`)}</div>
    <div class="field-row">${field("Vida útil (días) *", "number", "4")}${field("Precio de venta", "number", "35.00")}</div>
    <div class="field-row">${field("Stock de seguridad", "number", "2")}${field("Lote mínimo", "number", "1")}</div>
    ${switchRow("Aplicar recomendación", "Incluir en el plan diario", true)}
    <div class="modal-actions"><button class="button ghost" data-action="close-modal">Cancelar</button><button class="button" data-action="save-modal" data-message="Producto agregado al prototipo">Guardar</button></div>`;
}

function orderModal() {
  return `<h3>Registrar pedido</h3><p>La demanda confirmada se gestiona por separado.</p>
    ${field("Producto *", "select", "", productOptions())}${field("Cliente *", "text", "Cliente demostrativo")}
    <div class="field-row">${field("Fecha de entrega *", "date", "2026-06-28")}${field("Cantidad *", "number", "1")}</div>
    ${field("Descripción", "textarea", "Decoración y mensaje del pedido")}${field("Monto total *", "number", "45.00")}
    <div class="modal-actions"><button class="button ghost" data-action="close-modal">Cancelar</button><button class="button" data-action="save-modal" data-message="Pedido confirmado en el prototipo">Guardar</button></div>`;
}

drawerNav.innerHTML = routes.map((route) => `<button data-route="${route.id}"><b>${route.icon}</b><span>${route.title}</span></button>`).join("");

document.addEventListener("click", (event) => {
  const routeButton = event.target.closest("[data-route]");
  if (routeButton) {
    navigate(routeButton.dataset.route);
    return;
  }
  const action = event.target.closest("[data-action]");
  if (!action) return;
  const type = action.dataset.action;
  if (type === "new-product") openModal(productModal());
  if (type === "new-order") openModal(orderModal());
  if (type === "close-modal") closeModal();
  if (type === "save-modal") { closeModal(); showToast(action.dataset.message); }
  if (type === "save-transaction" || type === "prototype-toast") showToast(action.dataset.message);
  if (type === "toggle-recommendation") action.closest(".recommend-card").classList.toggle("open");
  if (type === "toggle-switch") action.classList.toggle("on");
});

document.querySelector("#menuButton").addEventListener("click", openDrawer);
document.querySelector("#modulesButton").addEventListener("click", openDrawer);
scrim.addEventListener("click", closeDrawer);
modalBackdrop.addEventListener("click", (event) => { if (event.target === modalBackdrop) closeModal(); });
window.addEventListener("keydown", (event) => { if (event.key === "Escape") { closeDrawer(); closeModal(); } });
window.addEventListener("hashchange", () => navigate(location.hash.slice(1)));

screen.addEventListener("input", (event) => {
  if (event.target.id === "productSearch") {
    state.productSearch = event.target.value;
    renderRoute();
    const input = document.querySelector("#productSearch");
    input.focus();
    input.setSelectionRange(input.value.length, input.value.length);
  }
});
screen.addEventListener("change", (event) => {
  if (event.target.id === "productCategory") {
    state.productCategory = event.target.value;
    renderRoute();
  }
});

navigate(location.hash.slice(1) || "inicio");
