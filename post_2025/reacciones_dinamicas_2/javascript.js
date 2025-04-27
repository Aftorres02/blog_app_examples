// Función principal que inicializa el panel de reacciones
function initReactionsPanel() {
  // Limpiar cualquier panel existente y sus event listeners
  cleanupExistingPanel();

  // Obtener el JSON de reacciones definido
  let reactions = [];
  try {
      // Intentar obtener reacciones del elemento APEX
      if (typeof apex !== 'undefined' && apex.item('P1130_REACTION_JSON')) {
          reactions = JSON.parse(apex.item('P1130_REACTION_JSON').getValue());
      }
  } catch (e) {
      console.error('Error al cargar reacciones:', e);
      return;
  }

  // Crear el panel de reacciones
  let reactionPanel = document.createElement('div');
  reactionPanel.id = 'reactions-panel';
  reactionPanel.className = 'reactions-panel';
  reactionPanel.style.display = 'none';
  document.body.appendChild(reactionPanel);

  // Crear contenido del panel basado en las reacciones
  populateReactionsPanel(reactionPanel, reactions);

  // Variables para controlar el comportamiento del panel
  let currentTriggerButton = null;
  let hideTimeout = null;

  // Obtener todos los botones de reacción
  const triggerButtons = document.querySelectorAll('.showReactions');

  if (triggerButtons.length === 0) {
      console.warn("No se encontraron elementos con la clase 'showReactions'");
      return;
  }

  console.log(`Se encontraron ${triggerButtons.length} botones de reacción`);

  // Función para posicionar el panel de reacciones
  function positionPanel(button) {
      const btnRect = button.getBoundingClientRect();
      const panelRect = reactionPanel.getBoundingClientRect();
      const scrollY = window.scrollY || document.documentElement.scrollTop;
      const scrollX = window.scrollX || document.documentElement.scrollLeft;

      // Determinar si mostrar arriba o abajo del botón
      let top;
      if (btnRect.top > panelRect.height + 10) {
          // Mostrar arriba si hay espacio
          top = btnRect.top + scrollY - panelRect.height - 10;
          reactionPanel.classList.remove('panel-bottom');
          reactionPanel.classList.add('panel-top');
      } else {
          // Mostrar abajo
          top = btnRect.bottom + scrollY + 10;
          reactionPanel.classList.remove('panel-top');
          reactionPanel.classList.add('panel-bottom');
      }

      // Centrar horizontalmente
      let left = btnRect.left + scrollX + (btnRect.width / 2) - (panelRect.width / 2);

      // Evitar que se salga de la pantalla
      if (left < 5) left = 5;
      if (left + panelRect.width > window.innerWidth - 5) {
          left = window.innerWidth - panelRect.width - 5;
      }

      reactionPanel.style.top = `${top}px`;
      reactionPanel.style.left = `${left}px`;
  }

  // Mostrar el panel
  function showPanel(button) {
      currentTriggerButton = button;
      clearTimeout(hideTimeout);

      reactionPanel.style.display = 'flex';
      // Esperar un momento para que se apliquen los estilos y se pueda calcular el tamaño
      setTimeout(() => {
          positionPanel(button);
          reactionPanel.classList.add('visible');
      }, 10);
  }

  // Ocultar el panel
  function hidePanel() {
      clearTimeout(hideTimeout);
      hideTimeout = setTimeout(() => {
          reactionPanel.classList.remove('visible');
          setTimeout(() => {
              if (!reactionPanel.classList.contains('visible')) {
                  reactionPanel.style.display = 'none';
              }
          }, 300); // Esperar a que termine la transición
      }, 200);
  }

  // Configurar eventos para los botones - Almacenar referencias para limpieza
  triggerButtons.forEach(button => {
      // Usar funciones nombradas para poder eliminarlas después
      button._showPanelHandler = () => showPanel(button);
      button._hidePanelHandler = () => hidePanel();

      button.addEventListener('mouseenter', button._showPanelHandler);
      button.addEventListener('mouseleave', button._hidePanelHandler);
  });

  // Eventos para el panel
  reactionPanel._mouseEnterHandler = () => clearTimeout(hideTimeout);
  reactionPanel._mouseLeaveHandler = () => hidePanel();

  reactionPanel.addEventListener('mouseenter', reactionPanel._mouseEnterHandler);
  reactionPanel.addEventListener('mouseleave', reactionPanel._mouseLeaveHandler);

  // Guardar referencias a funciones de eventos para poder limpiarlas después
  window._resizeHandler = () => {
      if (currentTriggerButton && reactionPanel.style.display !== 'none') {
          positionPanel(currentTriggerButton);
      }
  };

  window._scrollHandler = () => {
      if (currentTriggerButton && reactionPanel.style.display !== 'none') {
          positionPanel(currentTriggerButton);
      }
  };

  // Eventos de ventana para reposicionar el panel
  window.addEventListener('resize', window._resizeHandler);
  window.addEventListener('scroll', window._scrollHandler);
}

// Función para limpiar el panel existente y todos sus event listeners
function cleanupExistingPanel() {
  // Limpiar el panel antiguo si existe
  const existingPanel = document.getElementById('reactions-panel');
  if (existingPanel) {
      // Remover event listeners del panel
      if (existingPanel._mouseEnterHandler) {
          existingPanel.removeEventListener('mouseenter', existingPanel._mouseEnterHandler);
      }
      if (existingPanel._mouseLeaveHandler) {
          existingPanel.removeEventListener('mouseleave', existingPanel._mouseLeaveHandler);
      }

      // Eliminar el panel
      existingPanel.remove();
  }

  // Limpiar event listeners de los botones
  const oldButtons = document.querySelectorAll('.showReactions');
  oldButtons.forEach(button => {
      if (button._showPanelHandler) {
          button.removeEventListener('mouseenter', button._showPanelHandler);
      }
      if (button._hidePanelHandler) {
          button.removeEventListener('mouseleave', button._hidePanelHandler);
      }
  });

  // Limpiar event listeners de la ventana
  if (window._resizeHandler) {
      window.removeEventListener('resize', window._resizeHandler);
  }
  if (window._scrollHandler) {
      window.removeEventListener('scroll', window._scrollHandler);
  }
}

// Función para generar el contenido del panel de reacciones
function populateReactionsPanel(panel, reactions) {
  panel.innerHTML = '';

  reactions.forEach(reaction => {
      const reactionItem = document.createElement('div');
      reactionItem.className = 'reaction-item';
      reactionItem.dataset.reactionId = reaction.id;
      reactionItem.dataset.reactionCode = reaction.code;
      reactionItem.title = reaction.title;

      const iconElement = document.createElement('i');
      iconElement.className = reaction.emoji;

      const titleElement = document.createElement('span');
      titleElement.className = 'reaction-title';
      titleElement.textContent = reaction.title;

      reactionItem.appendChild(iconElement);
      reactionItem.appendChild(titleElement);
      panel.appendChild(reactionItem);
  });
}

// Inicializar en APEX o en un entorno normal
if (typeof apex !== 'undefined') {
 console.log("call init 1");
  apex.jQuery(document).on('apexreadyend', initReactionsPanel);
} else {
 console.log("call init 2");

  document.addEventListener('DOMContentLoaded', initReactionsPanel);
}