/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package flickandfeast;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;


import java.sql.*;

public class FlickandFeast extends JFrame {
    private static Connection conexion;
    private static String bd = "flickandfeastv2"; //<-- PONER EL NOMBRE DE LA BASE DE DATOS
    private static String user = "root";
    private static String password = ""; //<-- PONER CONTRASEÑA
    private static String host = "localhost";
    private static String server = "jdbc:mysql://" + host + "/" + bd + "?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC";

    public static void main(String[] args) {
        
        
        SwingUtilities.invokeLater(() -> {
            FlickandFeast ventana = new FlickandFeast();
            ventana.setVisible(true);
        });
        
        
        
    }
    // Panel principal con CardLayout para las secciones: Home, Facturación, Clientes
    private JPanel panelPrincipal;
    private CardLayout cardLayout;

    // Botones de la barra superior
    private JButton btnHome;
    private JButton btnFacturacion;
    private JButton btnClientes;

    // Paneles de las secciones principales
    private JPanel panelHome;
    private JPanel panelFacturacion;  // Aquí dentro tendremos Boletería y Confitería
    private JPanel panelClientes;

    private JLabel lblCliente;
    private Object[][] datos_clientes;
    JTextArea textAreaDetalle;
    
    JTable tablaClientes;
    
    String[] columnasClientes = {"ID Cliente", "Nombre", "Correo", "Dirección", "Puntos", "Tipo"};
    String[] colFunc = {"ID Funcion", "Película", "Sala", "Sede", "Hora Inicio", "Hora Fin", "Duracion", "Fecha"};
    String[] posiblesBeneficiarios = {"Nombre", "Correo", "Total de Compras", "Tipo de Memebresía"};
    
    String[] columnasHome = {"ID Funcion", "Película", "Sede", "Sala", "Asientos Disponibles", "Precio asiento", "Precio asiento preferencial", "Nombre alimento", "Precio Alimento"};
       
    Object[][] datosHome = chargue_data_home();
        
    JTable tablaHome = new JTable(new DefaultTableModel(datosHome, columnasHome));
    
    
    
    public FlickandFeast() {
        super("Flick & Feast Backstage");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setSize(1000, 600);
        setLocationRelativeTo(null);
        
        Color griscine = new Color(32, 31, 26);

        // ---------- Barra superior con botones ----------
        JPanel panelSuperior = new JPanel(new FlowLayout(FlowLayout.LEFT));
        panelSuperior.setBackground(griscine);
        
        //Color cute_yelllow =  new Color(253,230,138);
        Font emojiFont = new Font("Segoe UI Emoji", Font.BOLD, 14);
        
        btnHome = new JButton("🏠 Home");
        btnHome.setFont(emojiFont);
        btnHome.setBackground(griscine);
        btnHome.setForeground(Color.WHITE);
        
        btnFacturacion = new JButton("💳 Facturación y Encargos");
        btnFacturacion.setFont(emojiFont);
        btnFacturacion.setBackground(griscine);
        btnFacturacion.setForeground(Color.WHITE);
        
        btnClientes = new JButton("👤 Clientes y Suscripciones");
        btnClientes.setFont(emojiFont);
        btnClientes.setBackground(griscine);
        btnClientes.setForeground(Color.WHITE);

        panelSuperior.add(btnHome);
        panelSuperior.add(btnFacturacion);
        panelSuperior.add(btnClientes);

        // ---------- Panel principal con CardLayout ----------
        cardLayout = new CardLayout();
        panelPrincipal = new JPanel(cardLayout);

        // Crear las secciones principales
        panelHome = construirPanelHome();
        panelFacturacion = construirPanelFacturacion(); // Aquí tendremos Boletería/Confitería
        panelClientes = construirPanelClientesSuscripciones();

        // Agregarlas al CardLayout
        panelPrincipal.add(panelHome, "HOME");
        panelPrincipal.add(panelFacturacion, "FACTURACION");
        panelPrincipal.add(panelClientes, "CLIENTES");

        // Listeners para cambiar de sección
        btnHome.addActionListener(e -> {
            cardLayout.show(panelPrincipal, "HOME");
            actualizar_tabla(tablaHome,datosHome,columnasHome);
            //System.out.println("TEST!");
            });
        
        btnFacturacion.addActionListener(e -> cardLayout.show(panelPrincipal, "FACTURACION"));
        btnClientes.addActionListener(e -> cardLayout.show(panelPrincipal, "CLIENTES"));

        // Añadir todo al frame
        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(panelSuperior, BorderLayout.NORTH);
        getContentPane().add(panelPrincipal, BorderLayout.CENTER);
    }

    // -------------------------------------------------------------------------
    // SECCIÓN HOME (igual a tu código anterior, ajusta lo que necesites)
    // -------------------------------------------------------------------------
    private JPanel construirPanelHome() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(new Color(32, 31, 26));

        // Parte superior: Título
        JPanel panelTitulo = new JPanel(new BorderLayout());
        panelTitulo.setBackground(new Color(32, 31, 26));
        JLabel labelTitulo = new JLabel("");
        Font emojiFont = new Font("Segoe UI Emoji", Font.BOLD, 24);
        labelTitulo.setFont(emojiFont);
        labelTitulo.setForeground(Color.WHITE);
        labelTitulo.setFont(new Font("Arial", Font.BOLD, 24));
        labelTitulo.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 10));
        panelTitulo.add(labelTitulo, BorderLayout.WEST);
        

        panel.add(panelTitulo, BorderLayout.NORTH);

        // Parte central
        JPanel panelCentral = new JPanel();
        panelCentral.setLayout(new BoxLayout(panelCentral, BoxLayout.Y_AXIS));
        panelCentral.setBackground(new Color(32, 31, 26));

        JLabel labelBienvenida = new JLabel("<html><div style='text-align: center;'>¡Bienvenido(a) de vuelta a tu espacio de trabajo!</div></html>");
        labelBienvenida.setForeground(new Color(253,230,138));
        labelBienvenida.setFont(new Font("Arial", Font.BOLD, 16));
        labelBienvenida.setAlignmentX(Component.CENTER_ALIGNMENT);
        labelBienvenida.setBorder(BorderFactory.createEmptyBorder(10, 0, 10, 0));
        panelCentral.add(labelBienvenida);
        labelBienvenida.setHorizontalAlignment(SwingConstants.CENTER);

        // Imagen de cortina (opcional)
        //ImageIcon curtainIcon = new ImageIcon("red_curtain.jpg");
        
        // En el método construirPanelHome()
        ImageIcon curtainIcon = new ImageIcon(getClass().getResource("/flickandfeast/Resources/menu2.png"));

        //JLabel labelCurtain = new JLabel(curtainIcon);
        JLabel labelCurtain = new JLabel(curtainIcon);
        labelCurtain.setAlignmentX(Component.CENTER_ALIGNMENT);
        labelCurtain.setBorder(BorderFactory.createEmptyBorder(0, 0, 10, 0));
        
        panelTitulo.add(labelCurtain);
        
        
        JLabel labelMensaje = new JLabel("<html><div style='text-align: center;'>Explora estas posibles combinaciones para recomendar a nuestros clientes<br>y brindar el mejor servicio</div></html>");
        labelMensaje.setForeground(Color.WHITE);
        labelMensaje.setAlignmentX(Component.CENTER_ALIGNMENT);
        labelMensaje.setBorder(BorderFactory.createEmptyBorder(0, 10, 10, 10));
        panelCentral.add(labelMensaje);
        labelMensaje.setHorizontalAlignment(SwingConstants.CENTER);

        // Tabla de funciones
        JPanel panelTabla = new JPanel(new BorderLayout());
        panelTabla.setBackground(new Color(32, 31, 26));
        panelTabla.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        //String[] columnas = {"ID Funcion", "Película", "Sede", "Sala", "Asientos Disponibles", "Precio asiento", "Nombre alimento", "Precio Alimento"};
        
       
        //Object[][] datos = chargue_data_home();
        
        //JTable tablaHome = new JTable(new DefaultTableModel(datos, columnas));
        tablaHome.setFillsViewportHeight(true);
        tablaHome.setBackground(new Color(90, 0, 0));
        tablaHome.setForeground(Color.WHITE);
        tablaHome.setGridColor(Color.DARK_GRAY);
        tablaHome.setSelectionBackground(new Color(150, 0, 0));
        tablaHome.setSelectionForeground(Color.WHITE);

        // Estilo para la cabecera de columnas
        JTableHeader header = tablaHome.getTableHeader();
        header.setBackground(new Color(90, 20, 20));
        header.setForeground(Color.WHITE);
        header.setFont(header.getFont().deriveFont(Font.BOLD));

        JScrollPane scrollTabla = new JScrollPane(tablaHome);
        panelTabla.add(scrollTabla, BorderLayout.CENTER);

        panelCentral.add(panelTabla);

        panel.add(panelCentral, BorderLayout.CENTER);
        return panel;
    }

    // -------------------------------------------------------------------------
    // SECCIÓN FACTURACIÓN Y ENCARGOS
    //    - Usa un CardLayout interno para alternar Boletería y Confitería
    // -------------------------------------------------------------------------
    private JPanel construirPanelFacturacion() {
        // Panel principal de la sección
        JPanel panelFacturacion = new JPanel(new BorderLayout());
        panelFacturacion.setBackground(new Color(50, 20, 20));

        // ----------- Panel superior con botones Boletería y Confitería -----------
        JPanel panelOpciones = new JPanel(new FlowLayout(FlowLayout.LEFT));
        panelOpciones.setBackground(new Color(32, 31, 26));
        
        Color cute_yelllow =  new Color(253,230,138);
        
        JButton btnBoleteria = new JButton("Boletería");
        btnBoleteria.setBackground(cute_yelllow);
        btnBoleteria.setForeground(Color.BLACK);
        
        JButton btnConfiteria = new JButton("Confitería");
        btnConfiteria.setBackground(cute_yelllow);
        btnConfiteria.setForeground(Color.BLACK);
        
        panelOpciones.add(btnBoleteria);
        panelOpciones.add(btnConfiteria);
        
        JPanel panelTitulos = new JPanel();
        panelTitulos.setLayout(new BoxLayout(panelTitulos, BoxLayout.Y_AXIS));  // Para apilar los títulos verticalmente
        panelTitulos.setBackground(new Color(32, 31, 26));  // Color de fondo para el panel
        
        JLabel lblTituloPrincipal = new JLabel("Flick&Feast Backstage 🎬🍿");
        Font emojiFont = new Font("Segoe UI Emoji", Font.BOLD, 24);
        lblTituloPrincipal.setFont(emojiFont);
        lblTituloPrincipal.setForeground(Color.WHITE);  // Color blanco para el texto
        lblTituloPrincipal.setAlignmentX(Component.RIGHT_ALIGNMENT);  // Alineación al centro

        JLabel lblSubtitulo = new JLabel("Espacio de Facturación y Encargos: Boletería 🎬");
        Font subemojiFont = new Font("Segoe UI Emoji", Font.PLAIN, 18);
        lblSubtitulo.setFont(subemojiFont);
        lblSubtitulo.setForeground(Color.WHITE);
        lblSubtitulo.setAlignmentX(Component.RIGHT_ALIGNMENT);  // Alineación al centro
        
        panelTitulos.add(lblTituloPrincipal);
        panelTitulos.add(Box.createVerticalStrut(10));  // Espaciado entre títulos
        panelTitulos.add(lblSubtitulo);
        
        JPanel panelSuperior = new JPanel(new BorderLayout());
        panelSuperior.add(panelOpciones, BorderLayout.CENTER);  // Los botones a la izquierda
        panelSuperior.add(panelTitulos, BorderLayout.EAST);   // Los títulos a la derecha

    // Agregar el panelSuperior al panel principal
    panelFacturacion.add(panelSuperior, BorderLayout.NORTH);

        // ----------- Panel central con CardLayout para Boletería y Confitería -----------
        JPanel panelCentro = new JPanel(new CardLayout());
        panelCentro.setBackground(new Color(50, 20, 20));

        // Agregamos las dos “tarjetas”
        JPanel panelBoleteria = crearPanelBoleteria();
        JPanel panelConfiteria = crearPanelConfiteria(); 

        panelCentro.add(panelBoleteria, "BOLETERIA");
        panelCentro.add(panelConfiteria, "CONFITERIA");

        panelFacturacion.add(panelCentro, BorderLayout.CENTER);

        // Acciones de los botones para cambiar la vista
        btnBoleteria.addActionListener(e -> {
            CardLayout cl = (CardLayout) panelCentro.getLayout();
            cl.show(panelCentro, "BOLETERIA");
            lblSubtitulo.setText("Espacio de Facturación y Encargos: Boletería 🎬");
        });
        btnConfiteria.addActionListener(e -> {
            CardLayout cl = (CardLayout) panelCentro.getLayout();
            cl.show(panelCentro, "CONFITERIA");
            lblSubtitulo.setText("Espacio de Facturación y Encargos: Confitería 🍿");
        });

        return panelFacturacion;
    }

    // --------------------------
    // SUB-PANEL: BOLETERÍA
    // --------------------------
   private JPanel crearPanelBoleteria() {
    // Panel principal de Boletería
    JPanel panel = new JPanel(new BorderLayout());
    panel.setBackground(new Color(50, 20, 20));
    
    // ------------------------------------------------------------------
    // 1) Panel superior con 2 columnas: "Generar Boleta" y "Detalle de Venta"
    //    Usamos un GridLayout(1, 2) para que queden a la par y proporcionados
    // ------------------------------------------------------------------
    JPanel panelFormularios = new JPanel(new GridLayout(1, 2, 10, 10));
    panelFormularios.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
    panelFormularios.setBackground(new Color(32, 31, 26));
    
    // 2) Formulario para generar boleta (columna izquierda)
    JPanel panelFormulario = new JPanel(new GridBagLayout());
    panelFormulario.setBackground(new Color(90, 20, 20));
    TitledBorder tbFormulario = BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(Color.WHITE), "Generar Boleta");
    tbFormulario.setTitleColor(Color.WHITE);
    panelFormulario.setBorder(tbFormulario);

    GridBagConstraints gbc = new GridBagConstraints();
    gbc.insets = new Insets(5, 5, 5, 5);
    gbc.anchor = GridBagConstraints.LINE_END;

    gbc.gridx = 0;
    gbc.gridy = 0;
    JLabel lblFecha = new JLabel("ID Cliente:");
    lblFecha.setForeground(Color.WHITE);
    panelFormulario.add(lblFecha, gbc);
    gbc.gridx++;
    JTextField txtIdCliente = new JTextField(10);
    panelFormulario.add(txtIdCliente, gbc);

    gbc.gridx = 0;
    gbc.gridy++;
    JLabel lblPelicula = new JLabel("Función:");
    lblPelicula.setForeground(Color.WHITE);
    panelFormulario.add(lblPelicula, gbc);
    gbc.gridx++;
    JTextField txtFuncion = new JTextField(10);
    panelFormulario.add(txtFuncion, gbc);

    gbc.gridx = 0;
    gbc.gridy++;
    JLabel lblOrigen = new JLabel("Silla:");
    lblOrigen.setForeground(Color.WHITE);
    panelFormulario.add(lblOrigen, gbc);
    gbc.gridx++;
    JTextField txtSilla = new JTextField(10);
    panelFormulario.add(txtSilla, gbc);

    gbc.gridx = 0;
    gbc.gridy++;
    JLabel lblTipo = new JLabel("Tipo de servicio:");
    lblTipo.setForeground(Color.WHITE);
    panelFormulario.add(lblTipo, gbc);
    gbc.gridx++;
    JComboBox<String> comboTipo = new JComboBox<>(new String[]{"Servicio A", "Servicio B", "Servicio C"});
    panelFormulario.add(comboTipo, gbc);

    gbc.gridx = 0;
    gbc.gridy++;
    JLabel lblCantidad = new JLabel("Cantidad:");
    lblCantidad.setForeground(Color.WHITE);
    panelFormulario.add(lblCantidad, gbc);
    gbc.gridx++;
    JTextField txtCantidad = new JTextField(10);
    panelFormulario.add(txtCantidad, gbc);
    gbc.gridx = 0;
    gbc.gridy++;
    
    JLabel lblEmpleado = new JLabel("ID Empleado en Taquilla:");
    lblEmpleado.setForeground(Color.WHITE);
    panelFormulario.add(lblEmpleado, gbc);
    gbc.gridx++;
    JTextField txtEmpleado = new JTextField(10);
    panelFormulario.add(txtEmpleado, gbc);

    gbc.gridx = 0;
    gbc.gridy++;
    JLabel lblMedioPago = new JLabel("Medio de Pago:");
    lblMedioPago.setForeground(Color.WHITE);
    panelFormulario.add(lblMedioPago, gbc);
    gbc.gridx++;
    JComboBox<String> comboMedioPago = new JComboBox<>(new String[]{"Efectivo", "Tarjeta", "Otro"});
    panelFormulario.add(comboMedioPago, gbc);

    gbc.gridx = 0;
    gbc.gridy++;
    gbc.gridwidth = 1;
    gbc.anchor = GridBagConstraints.CENTER;
    
    Color cute_red = new Color(235,20,76);
    
    JButton btnCancelar = new JButton("Cancelar");
    btnCancelar.setBackground(cute_red);
    btnCancelar.setForeground(Color.WHITE);
    panelFormulario.add(btnCancelar, gbc);

    gbc.gridx++;
    
    Color low_green = new Color(17,122,56);
    
    JButton btnVender = new JButton("Vender");
    btnVender.setBackground(low_green);
    btnVender.setForeground(Color.WHITE);
    panelFormulario.add(btnVender, gbc);
    

    // Añadimos el panel de Formulario (Generar Boleta) al panelFormularios (columna 1)
    panelFormularios.add(panelFormulario);

    // 3) Detalle de Venta Generado (columna derecha)
    JPanel panelDetalle = new JPanel(new BorderLayout());
    panelDetalle.setBackground(new Color(90, 20, 20));
    TitledBorder tbDetalle = BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(Color.WHITE),
            "Detalle de Venta Generado"
    );
    tbDetalle.setTitleColor(Color.WHITE);
    panelDetalle.setBorder(tbDetalle);

    textAreaDetalle = new JTextArea(10, 20);
    textAreaDetalle.setEditable(false);
    JScrollPane scrollDetalle = new JScrollPane(textAreaDetalle);
    panelDetalle.add(scrollDetalle, BorderLayout.CENTER);

    // Añadimos el panelDetalle (Detalle de Venta) al panelFormularios (columna 2)
    panelFormularios.add(panelDetalle);

    // Agregamos el panelFormularios en la parte superior (NORTH) del panel principal
    panel.add(panelFormularios, BorderLayout.NORTH);

    // ------------------------------------------------------------------
    // 4) Panel inferior: Tabla de Funciones
    // ------------------------------------------------------------------
    JPanel panelTabla = new JPanel(new BorderLayout());
    panelTabla.setBackground(new Color(32, 31, 26));
    TitledBorder tbTabla = BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(Color.WHITE),
            "Información de Funciones"
    );
    tbTabla.setTitleColor(Color.WHITE);
    panelTabla.setBorder(tbTabla);

    // Columnas y datos de ejemplo (o tu método real para cargar funciones)
    Object[][] datosFunc = charge_functions_form();

    JTable tablaFunciones = new JTable(new DefaultTableModel(datosFunc, colFunc));
    tablaFunciones.setFillsViewportHeight(true);
    tablaFunciones.setBackground(new Color(90, 20, 20));
    tablaFunciones.setForeground(Color.WHITE);
    tablaFunciones.setGridColor(Color.DARK_GRAY);
    tablaFunciones.setSelectionBackground(new Color(150, 0, 0));
    tablaFunciones.setSelectionForeground(Color.WHITE);

    // Estilo para la cabecera de columnas
    JTableHeader header = tablaFunciones.getTableHeader();
    header.setBackground(new Color(90, 20, 20));
    header.setForeground(Color.WHITE);
    header.setFont(header.getFont().deriveFont(Font.BOLD));

    JScrollPane scrollTablaFunciones = new JScrollPane(tablaFunciones);
    panelTabla.add(scrollTablaFunciones, BorderLayout.CENTER);

    // Añadimos el panelTabla en la parte central (CENTER) del panel principal
    panel.add(panelTabla, BorderLayout.CENTER);

    // ------------------------------------------------------------------
    // Acciones de los botones
    // ------------------------------------------------------------------
    btnVender.addActionListener(new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
            
            if (txtIdCliente.getText().equals("") || txtFuncion.getText().equals("") || txtSilla.getText().equals("")  || txtCantidad.getText().equals("") || txtEmpleado.getText().equals("")){
                txtIdCliente.setText("");
                txtFuncion.setText("");
                txtSilla.setText("");
                txtCantidad.setText("");
                txtEmpleado.setText("");
                textAreaDetalle.setText("ERROR: Datos incompletos\n");

                
            }
            else{
                int id = Integer.parseInt(txtIdCliente.getText());
                int funcion = Integer.parseInt(txtFuncion.getText());
                int silla = Integer.parseInt(txtSilla.getText());
                String tipo_servicio = (String) comboTipo.getSelectedItem();
                int cantidad = Integer.parseInt(txtCantidad.getText());
                int id_empleado = Integer.parseInt(txtEmpleado.getText());
                String medio = (String) comboMedioPago.getSelectedItem();
            
                generar_boleta(id, id_empleado, tipo_servicio, medio, cantidad, funcion, silla);
                
            }
            
        }
    });

    btnCancelar.addActionListener(new ActionListener() {
        @Override
        public void actionPerformed(ActionEvent e) {
            // Limpiar campos
            txtIdCliente.setText("");
            txtFuncion.setText("");
            txtSilla.setText("");
            txtCantidad.setText("");
            textAreaDetalle.setText("Venta Cancelada\n");
            // comboTipo.setSelectedIndex(0);
            // comboMedioPago.setSelectedIndex(0);
        }
    });

    return panel;
}


    // --------------------------
    // SUB-PANEL: CONFITERÍA
    // --------------------------
    private JPanel crearPanelConfiteria() {
        // Panel principal de Confitería
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(new Color(50, 20, 20));

        // ------------------------------------------------------------------
        // Panel superior: contendrá dos paneles (Pedido y Encargo de Alimentos Generado)
        // Usamos un GridLayout(1, 2) para que queden del mismo tamaño y proporción.
        // ------------------------------------------------------------------
        JPanel panelSuperior = new JPanel(new GridLayout(1, 2, 10, 10));
        panelSuperior.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelSuperior.setBackground(new Color(32, 31, 26));

        // 1) Panel "Pedido"
        JPanel panelPedido = new JPanel(new GridBagLayout());
        panelPedido.setBackground(new Color(90, 20, 20));
        TitledBorder borderPedido = BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.WHITE), "Pedido"
        );
        borderPedido.setTitleColor(Color.WHITE);
        panelPedido.setBorder(borderPedido);

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.anchor = GridBagConstraints.LINE_END;

        JLabel lblIdCliente = new JLabel("ID Cliente:");
        lblIdCliente.setForeground(Color.WHITE);
        panelPedido.add(lblIdCliente, gbc);
        gbc.gridx++;
        JTextField txtIdCliente = new JTextField(12);
        panelPedido.add(txtIdCliente, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblAlimento = new JLabel("Nombre del alimento:");
        lblAlimento.setForeground(Color.WHITE);
        panelPedido.add(lblAlimento, gbc);
        gbc.gridx++;
        JTextField txtAlimento = new JTextField(12);
        panelPedido.add(txtAlimento, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblCantidad = new JLabel("Cantidad:");
        lblCantidad.setForeground(Color.WHITE);
        panelPedido.add(lblCantidad, gbc);
        gbc.gridx++;
        JTextField txtCantidad = new JTextField(12);
        panelPedido.add(txtCantidad, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblNotas = new JLabel("Notas / Observaciones:");
        lblNotas.setForeground(Color.WHITE);
        panelPedido.add(lblNotas, gbc);
        gbc.gridx++;
        JTextField txtNotas = new JTextField(12);
        panelPedido.add(txtNotas, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        gbc.gridwidth = 1;
        gbc.anchor = GridBagConstraints.CENTER;
        
        Color cute_red = new Color(235,20,76);
        
        JButton btnCancelar = new JButton("Cancelar");
        btnCancelar.setBackground(cute_red);
        btnCancelar.setForeground(Color.WHITE);
        panelPedido.add(btnCancelar, gbc);

        gbc.gridx++;
        
        Color low_green = new Color(17,122,56);
        
        JButton btnEntregar = new JButton("Encargar");
        btnEntregar.setBackground(low_green);
        btnEntregar.setForeground(Color.WHITE);
        panelPedido.add(btnEntregar, gbc);

        // 2) Panel "Encargo de Alimentos Generado"
        JPanel panelEncargo = new JPanel(new BorderLayout());
        panelEncargo.setBackground(new Color(90, 20, 20));
        TitledBorder borderEncargo = BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.WHITE),
                "Encargo de Alimentos Generado"
        );
        borderEncargo.setTitleColor(Color.WHITE);
        panelEncargo.setBorder(borderEncargo);

        JTextArea textAreaEncargo = new JTextArea(10, 20);
        textAreaEncargo.setEditable(false);
        JScrollPane scrollEncargo = new JScrollPane(textAreaEncargo);
        panelEncargo.add(scrollEncargo, BorderLayout.CENTER);

        // Agregamos los dos paneles al panelSuperior
        panelSuperior.add(panelPedido);
        panelSuperior.add(panelEncargo);

        // Colocamos el panelSuperior en la parte NORTE del panel principal
        panel.add(panelSuperior, BorderLayout.NORTH);

        // ------------------------------------------------------------------
        // Panel inferior: Oferta de Alimentos y Bebidas
        // ------------------------------------------------------------------
        JPanel panelOferta = new JPanel(new BorderLayout());
        panelOferta.setBackground(new Color(32, 31, 26));
        TitledBorder borderOferta = BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.WHITE),
                "Oferta de Alimentos y Bebidas"
        );
        borderOferta.setTitleColor(Color.WHITE);
        panelOferta.setBorder(borderOferta);

        String[] cols = {"Alimento", "Proveedor", "Precio", "Tamaño", "Empaque"};
        Object[][] data = charge_products_form();

        JTable tablaOferta = new JTable(new DefaultTableModel(data, cols));
        tablaOferta.setFillsViewportHeight(true);
        tablaOferta.setBackground(new Color(90, 20, 20));
        tablaOferta.setForeground(Color.WHITE);
        tablaOferta.setGridColor(Color.DARK_GRAY);
        tablaOferta.setSelectionBackground(new Color(150, 0, 0));
        tablaOferta.setSelectionForeground(Color.WHITE);

        JTableHeader header = tablaOferta.getTableHeader();
        header.setBackground(new Color(90, 20, 20));
        header.setForeground(Color.WHITE);
        header.setFont(header.getFont().deriveFont(Font.BOLD));

        JScrollPane scrollOferta = new JScrollPane(tablaOferta);
        panelOferta.add(scrollOferta, BorderLayout.CENTER);

        // Se agrega el panel de Oferta en el centro del panel principal
        panel.add(panelOferta, BorderLayout.CENTER);

        // ------------------------------------------------------------------
        // Acciones de ejemplo para los botones
        // ------------------------------------------------------------------
        btnEntregar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String detalle = "Encargo:\n" +
                        "ID Cliente: " + txtIdCliente.getText()+ "\n" +
                        "Producto: " + txtAlimento.getText() + "\n" +
                        "Cantidad: " + txtCantidad.getText() + "\n" +
                        "Notas: " + txtNotas.getText() + "\n";
                textAreaEncargo.setText(detalle);
                
                
                if (txtAlimento.getText().equals("") || txtCantidad.getText().equals("") || txtNotas.getText().equals("")){
                    txtIdCliente.setText("");
                    txtAlimento.setText("");
                    txtCantidad.setText("");
                    txtNotas.setText("");
                    textAreaEncargo.setText("ERROR: Datos incompletos\n");
                
                }
                else{
                    int id = Integer.parseInt(txtIdCliente.getText());
                    String producto = txtAlimento.getText();
                    int cantidad = Integer.parseInt(txtCantidad.getText());
                    enargar_pedido(id, producto, cantidad);

                
            }
                
                
            }
        });

        btnCancelar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                txtIdCliente.setText("");
                txtAlimento.setText("");
                txtCantidad.setText("");
                txtNotas.setText("");
                textAreaEncargo.setText("Pedido Cancelado\n");
            }
        });
    
    return panel;
}


    // -------------------------------------------------------------------------
    // SECCIÓN CLIENTES Y SUSCRIPCIONES (igual que antes)
    // -------------------------------------------------------------------------
    
    private JPanel construirPanelClientesSuscripciones() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(new Color(32, 31, 26));
        
        // --------------------------------------
        // 1) CREAR PANEL DE TÍTULOS
        // --------------------------------------
                JPanel panelTitulos = new JPanel();
                panelTitulos.setLayout(new BoxLayout(panelTitulos, BoxLayout.Y_AXIS));  // Alinear verticalmente
                panelTitulos.setBackground(new Color(32, 31, 26));  // Color de fondo

        // Título principal
                JLabel lblTituloPrincipal = new JLabel("Flick&Feast Backstage 🎬 🍿");
                Font emojiFont = new Font("Segoe UI Emoji", Font.BOLD, 24);
                lblTituloPrincipal.setFont(emojiFont);
                lblTituloPrincipal.setForeground(Color.WHITE);  // Color blanco
                lblTituloPrincipal.setAlignmentX(Component.RIGHT_ALIGNMENT);

        // Subtítulo
                JLabel lblSubtitulo = new JLabel("Zona de Clientes y Suscripciones 📇");
                Font subemojiFont = new Font("Segoe UI Emoji", Font.PLAIN, 18);
                lblSubtitulo.setFont(subemojiFont);
                lblSubtitulo.setForeground(Color.WHITE);
                lblSubtitulo.setAlignmentX(Component.RIGHT_ALIGNMENT);

        // Agregar títulos al panel
                panelTitulos.add(lblTituloPrincipal);
                panelTitulos.add(Box.createVerticalStrut(10));  // Espaciado entre títulos
                panelTitulos.add(lblSubtitulo);
        
        // ---------------------------------------------------------------------
        // 2) Crear el panelFormularios (Zona de Clientes + Nueva Suscripción)
        // ---------------------------------------------------------------------
        JPanel panelFormularios = new JPanel(new GridLayout(1, 2, 10, 10));
        panelFormularios.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        panelFormularios.setBackground(new Color(32, 31, 26));

        // ---------------------------
        // ZONA DE CLIENTES
        // ---------------------------
        JPanel zonaClientes = new JPanel(new BorderLayout());
        zonaClientes.setBackground(new Color(90, 20, 20));
        TitledBorder tbClientes = BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.WHITE), "Zona de Clientes");
        tbClientes.setTitleColor(Color.WHITE);
        zonaClientes.setBorder(tbClientes);

        // Barra superior (Registro / Actualización)
        JPanel panelBotones = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        panelBotones.setBackground(new Color(90, 20, 20));
        
        Color cute_yelllow =  new Color(253,230,138);
        
        JButton btnRegistro = new JButton("Registro");
        btnRegistro.setBackground(cute_yelllow);
        btnRegistro.setForeground(Color.BLACK);
        
        JButton btnActualizacion = new JButton("Actualización de datos");
        btnActualizacion.setBackground(cute_yelllow);
        btnActualizacion.setForeground(Color.BLACK);
        
        panelBotones.add(btnRegistro);
        panelBotones.add(btnActualizacion);

        zonaClientes.add(panelBotones, BorderLayout.NORTH);

        // CardLayout para mostrar panelRegistro o panelActualizacion
        JPanel panelCentralZona = new JPanel(new CardLayout());
        panelCentralZona.setBackground(new Color(90, 20, 20));

        JPanel panelRegistro = crearPanelRegistro();
        JPanel panelActualizacion = crearPanelActualizacion();

        panelCentralZona.add(panelRegistro, "REGISTRO");
        panelCentralZona.add(panelActualizacion, "ACTUALIZACION");

        // Botones para alternar entre paneles
        btnRegistro.addActionListener(e -> {
            CardLayout cl = (CardLayout) panelCentralZona.getLayout();
            cl.show(panelCentralZona, "REGISTRO");
        });
        btnActualizacion.addActionListener(e -> {
            CardLayout cl = (CardLayout) panelCentralZona.getLayout();
            cl.show(panelCentralZona, "ACTUALIZACION");
        });

        zonaClientes.add(panelCentralZona, BorderLayout.CENTER);

        // Agregamos la Zona de Clientes al panel de formularios
        panelFormularios.add(zonaClientes);

        // ---------------------------
        // NUEVA SUSCRIPCIÓN
        // ---------------------------
        JPanel nuevaSuscripcion = new JPanel(new GridBagLayout());
        nuevaSuscripcion.setBackground(new Color(90, 20, 20));
        TitledBorder tbSuscripcion = BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.WHITE), "Nueva Suscripción");
        tbSuscripcion.setTitleColor(Color.WHITE);
        nuevaSuscripcion.setBorder(tbSuscripcion);

        GridBagConstraints gbc2 = new GridBagConstraints();
        gbc2.insets = new Insets(5, 5, 5, 5);
        gbc2.anchor = GridBagConstraints.WEST;

        gbc2.gridx = 0;
        gbc2.gridy = 0;
        JLabel lblId2 = new JLabel("Número de Identificación:");
        lblId2.setForeground(Color.WHITE);
        nuevaSuscripcion.add(lblId2, gbc2);
        gbc2.gridx++;
        JTextField txtId2 = new JTextField(10);
        nuevaSuscripcion.add(txtId2, gbc2);

        gbc2.gridx = 0;
        gbc2.gridy++;
        JLabel lblMembresia = new JLabel("Tipo de Membresía:");
        lblMembresia.setForeground(Color.WHITE);
        nuevaSuscripcion.add(lblMembresia, gbc2);
        gbc2.gridx++;
        JComboBox<String> comboMembresia = new JComboBox<>(new String[] {"VIP", "Advanced", "Basic"});
        nuevaSuscripcion.add(comboMembresia, gbc2);

        gbc2.gridx = 0;
        gbc2.gridy++;
        JLabel lblMedioPago = new JLabel("Medio de Pago:");
        lblMedioPago.setForeground(Color.WHITE);
        nuevaSuscripcion.add(lblMedioPago, gbc2);
        gbc2.gridx++;
        JComboBox<String> comboMedioPago2 = new JComboBox<>(new String[] {"Tarjeta", "Efectivo", "PayPal"});
        nuevaSuscripcion.add(comboMedioPago2, gbc2);

        gbc2.gridx = 0;
        gbc2.gridy++;
        gbc2.gridwidth = 2;
        gbc2.anchor = GridBagConstraints.CENTER;
        
        //Color cute_yelllow =  new Color(253,230,138);
        
        JButton btnGenerarSuscripcion = new JButton("Generar Suscripción");      
        btnGenerarSuscripcion.setBackground(cute_yelllow);
        nuevaSuscripcion.add(btnGenerarSuscripcion, gbc2);
        btnGenerarSuscripcion.addActionListener(e -> {
        try {
            // Limpiar los campos del formulario
            int id = Integer.parseInt(txtId2.getText());
            String tipo = (String) comboMembresia.getSelectedItem();

            // Llamar al método para registrar el nuevo cliente
            nueva_suscripcion(id, tipo);

        } catch (Exception ex) {
            // Manejo general de excepciones
            lblCliente.setText("Error al generar suscripcion: ");
        }
    });

        // Agregamos la Nueva Suscripción al panel de formularios
        panelFormularios.add(nuevaSuscripcion);

        // ---------------------------------------------------------------------
        // 2) Crear un panel "superior" que contendrá:
        //    - Arriba: panelFormularios
        //    - Centro: botón "Posibles Beneficiarios"
        // ---------------------------------------------------------------------
        JPanel panelSuperior = new JPanel(new BorderLayout());
        panelSuperior.setBackground(new Color(32, 31, 26));

        // Añadimos el panelFormularios en la parte de arriba
        panelSuperior.add(panelFormularios, BorderLayout.NORTH);

        // Crear un subpanel para el botón "Posibles Beneficiarios"
        JPanel panelBotonBeneficiarios = new JPanel(new FlowLayout(FlowLayout.LEFT));
        panelBotonBeneficiarios.setBackground(new Color(32, 31, 26));

        // Botón tipo toggle
        JToggleButton toggleBeneficiarios = new JToggleButton("Posibles Beneficiarios");
        toggleBeneficiarios.setBackground(cute_yelllow);
        toggleBeneficiarios.setForeground(Color.BLACK);
        toggleBeneficiarios.addActionListener(e -> {
        if (toggleBeneficiarios.isSelected()) {
            Object[][] datosClientes = posibles_beneficiarios();
            actualizar_tabla(tablaClientes, datosClientes, posiblesBeneficiarios);
            lblCliente.setText("Mostrando posibles beneficiarios");
        }
        else {
            Object[][] datosClientes = charge_clients_form();
            actualizar_tabla(tablaClientes, datosClientes, columnasClientes);
            lblCliente.setText("");
        }
        });
        
        lblCliente = new JLabel("");  // Inicialmente vacío
        lblCliente.setForeground(Color.WHITE);  // Color verde para mensajes de éxito
        lblCliente.setFont(new Font("Arial", Font.BOLD, 14));  // Fuente en negrita
        lblCliente.setHorizontalAlignment(SwingConstants.CENTER);  // Centrado

        panelBotonBeneficiarios.add(toggleBeneficiarios);
        
        JPanel panelMensaje = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 10));
        panelMensaje.setBackground(new Color(32, 31, 26));  // Color de fondo

        // Añadir el JLabel al panelMensaje (para centrarlo)
        panelMensaje.add(lblCliente);

        // Añadimos este subpanel al centro de panelSuperior
        panelSuperior.add(panelBotonBeneficiarios, BorderLayout.WEST);
        panelSuperior.add(panelMensaje, BorderLayout.CENTER);


        JPanel contenedorSuperior = new JPanel(new BorderLayout());
        contenedorSuperior.setBackground(new Color(50, 20, 20));  // Mismo color de fondo
        contenedorSuperior.add(panelTitulos, BorderLayout.NORTH);  // Agregar títulos arriba
        contenedorSuperior.add(panelSuperior, BorderLayout.CENTER);  // Agregar panelSuperior abajo
        
        // Finalmente, ponemos contenedorSuperior en la parte NORTH del panel principal
        panel.add(contenedorSuperior, BorderLayout.NORTH);
        
        // ---------------------------------------------------------------------
        // 3) DIRECTORIO DE CLIENTES (Tabla inferior)
        // ---------------------------------------------------------------------
        JPanel panelTabla = new JPanel(new BorderLayout());
        panelTabla.setBackground(new Color(32, 31, 26)); 
        TitledBorder tbDirectorio = BorderFactory.createTitledBorder(
                BorderFactory.createLineBorder(Color.WHITE), "Directorio de Clientes");
        tbDirectorio.setTitleColor(Color.WHITE);
        panelTabla.setBorder(tbDirectorio);

        // Columnas y datos de la tabla
        datos_clientes = charge_clients_form();

        tablaClientes = new JTable(new DefaultTableModel(datos_clientes, columnasClientes));
        // ---- Aplicamos el mismo estilo que en Boletería/Confitería ----
        tablaClientes.setFillsViewportHeight(true);
        tablaClientes.setBackground(new Color(90, 20, 20));
        tablaClientes.setForeground(Color.WHITE);
        tablaClientes.setGridColor(Color.DARK_GRAY);
        tablaClientes.setSelectionBackground(new Color(150, 0, 0));
        tablaClientes.setSelectionForeground(Color.WHITE);

        // Estilo para la cabecera de columnas
        tablaClientes.getTableHeader().setBackground(new Color(90, 20, 20));
        tablaClientes.getTableHeader().setForeground(Color.WHITE);

        JScrollPane scrollClientes = new JScrollPane(tablaClientes);
        // scrollClientes.getViewport().setBackground(new Color(90, 20, 20)); // Si deseas fondo oscuro en el viewport

        //panelTabla.add(lblMensaje, BorderLayout.NORTH);  // Aquí lo agregamos arriba de la tabla
        
        // Añadimos la tabla al panel
        panelTabla.add(scrollClientes, BorderLayout.CENTER);

        // Añadimos el panelTabla en la parte CENTER del panel principal
        panel.add(panelTabla, BorderLayout.CENTER);

    return panel;
}

    // ------------------------------
    // SUB-PANEL: REGISTRO DE CLIENTE
    // ------------------------------
    private JPanel crearPanelRegistro() {
        JPanel panelRegistro = new JPanel(new GridBagLayout());
        panelRegistro.setBackground(new Color(90, 20, 20));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.anchor = GridBagConstraints.WEST;

        gbc.gridx = 0;
        gbc.gridy = 0;
        JLabel lblId = new JLabel("Número de Identificación:");
        lblId.setForeground(Color.WHITE);
        panelRegistro.add(lblId, gbc);
        gbc.gridx++;
        JTextField txtId = new JTextField(10);
        panelRegistro.add(txtId, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblNombre = new JLabel("Nombre:");
        lblNombre.setForeground(Color.WHITE);
        panelRegistro.add(lblNombre, gbc);
        gbc.gridx++;
        JTextField txtNombre = new JTextField(10);
        panelRegistro.add(txtNombre, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblCorreo = new JLabel("Correo Electrónico:");
        lblCorreo.setForeground(Color.WHITE);
        panelRegistro.add(lblCorreo, gbc);
        gbc.gridx++;
        JTextField txtCorreo = new JTextField(10);
        panelRegistro.add(txtCorreo, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblDireccion = new JLabel("Dirección:");
        lblDireccion.setForeground(Color.WHITE);
        panelRegistro.add(lblDireccion, gbc);
        gbc.gridx++;
        JTextField txtDireccion = new JTextField(10);
        panelRegistro.add(txtDireccion, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        
        Color cute_red = new Color(235,20,76);
        
        JButton btnCancelar = new JButton("Cancelar");
        btnCancelar.setBackground(cute_red);
        btnCancelar.setForeground(Color.WHITE);
        panelRegistro.add(btnCancelar, gbc);
        gbc.gridx++;
        btnCancelar.addActionListener(e -> {
        try {
            // Limpiar los campos del formulario
            txtId.setText("");
            txtNombre.setText("");
            txtCorreo.setText("");
            txtDireccion.setText("");

            // Mostrar el mensaje en el JLabel
            lblCliente.setText("Registro Cancelado");
        } catch (Exception ex) {
            // Manejo general de excepciones
            lblCliente.setText("Error al cancelar el registro: " + ex.getMessage());
        }
    });

        
        Color low_green = new Color(17,122,56);
        
        JButton btnRegistrar = new JButton("Registrar");
        btnRegistrar.setBackground(low_green);
        btnRegistrar.setForeground(Color.WHITE);
        panelRegistro.add(btnRegistrar, gbc);
        btnRegistrar.addActionListener(e -> {
        try {
            // Obtener los datos del formulario
            int id = Integer.parseInt(txtId.getText());
            String nombre = txtNombre.getText();
            String correo = txtCorreo.getText();
            String direccion = txtDireccion.getText();

            // Llamar al método para registrar el nuevo cliente
            registrar_cliente(id, nombre, correo, direccion);

            // Limpiar los campos del formulario después del registro
            txtId.setText("");
            txtNombre.setText("");
            txtCorreo.setText("");
            txtDireccion.setText("");

            // Mostrar el mensaje en el JLabel
            lblCliente.setText("¡Nuevo cliente registrado correctamente!");
            } catch (NumberFormatException ex) {
            // Manejo de error si el ID no es un número válido
            lblCliente.setText("Por favor ingrese un ID válido.");
            } catch (Exception ex) {
                // Manejo general de excepciones
                lblCliente.setText("Ups! Algo salió mal, intente de nuevo");
            }
    });
       
        return panelRegistro;
    }

    // ---------------------------------
    // SUB-PANEL: ACTUALIZACIÓN DE DATOS
    // ---------------------------------
    private JPanel crearPanelActualizacion() {
        JPanel panelActualizacion = new JPanel(new GridBagLayout());
        panelActualizacion.setBackground(new Color(90, 20, 20));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5,5,5,5);
        gbc.anchor = GridBagConstraints.WEST;

        gbc.gridx = 0;
        gbc.gridy = 0;
        JLabel lblId = new JLabel("Número de Identificación:");
        lblId.setForeground(Color.WHITE);
        panelActualizacion.add(lblId, gbc);
        gbc.gridx++;
        
        JTextField txtId = new JTextField(10);
        panelActualizacion.add(txtId, gbc);

        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblDatoActualizar = new JLabel("Dato a Actualizar:");
        lblDatoActualizar.setForeground(Color.WHITE);
        panelActualizacion.add(lblDatoActualizar, gbc);
        gbc.gridx++;
        JComboBox<String> comboDatoActualizar = new JComboBox<>(new String[]{"Nombre", "Correo", "Dirección"});
        panelActualizacion.add(comboDatoActualizar, gbc);
        
        gbc.gridx = 0;
        gbc.gridy++;
        JLabel lblNuevoValor = new JLabel("Nuevo Valor:");
        lblNuevoValor.setForeground(Color.WHITE);
        panelActualizacion.add(lblNuevoValor, gbc);
        gbc.gridx++;
        JTextField txtNuevoValor = new JTextField(10);
        panelActualizacion.add(txtNuevoValor, gbc);

        
        gbc.gridx = 0;
        gbc.gridy++;
       
        
        Color cute_red = new Color(235,20,76);
        
        JButton btnCancelar = new JButton("Cancelar");
        btnCancelar.setBackground(cute_red);
        btnCancelar.setForeground(Color.WHITE);
        panelActualizacion.add(btnCancelar, gbc);
        gbc.gridx++;
        btnCancelar.addActionListener(e -> {
        try {
            // Limpiar los campos del formulario
            txtId.setText("");
            txtNuevoValor.setText("");

            // Mostrar el mensaje en el JLabel
            lblCliente.setText("Actualización Cancelada");
        } catch (Exception ex) {
            // Manejo general de excepciones
            lblCliente.setText("Error al cancelar la actualización: " + ex.getMessage());
        }
        });
        
        Color low_green =  new Color(17,122,56);
        
        JButton btnActualizar = new JButton("Actualizar");
        btnActualizar.setBackground(low_green);
        btnActualizar.setForeground(Color.WHITE);
        panelActualizacion.add(btnActualizar, gbc);
        btnActualizar.addActionListener(e -> {
        try {
            // Obtener los datos del formulario
            int id = Integer.parseInt(txtId.getText());
            String dato_actualizar = (String) comboDatoActualizar.getSelectedItem();
            String nuevo_valor = txtNuevoValor.getText();
            
            if (dato_actualizar.equals("Nombre")) {
                dato_actualizar = "cliNombre";
            }
            else if (dato_actualizar.equals("Correo")) {
                dato_actualizar = "cliCorreo";
            }
            else {
                dato_actualizar = "cliDireccion";
            }
            
            // Llamar al método para registrar el nuevo cliente
            actualizar_cliente(id, dato_actualizar, nuevo_valor);

            // Limpiar los campos del formulario después del registro
            txtId.setText("");
            txtNuevoValor.setText("");

            // Mostrar el mensaje en el JLabel
            lblCliente.setText("¡Información actualizada correctamente!");
            } catch (NumberFormatException ex) {
            // Manejo de error si el ID no es un número válido
            lblCliente.setText("Por favor ingrese un ID válido.");
            } catch (Exception ex) {
            // Manejo general de excepciones
            lblCliente.setText("Ups! Algo salió mal, intente de nuevo");
            }
    });

        return panelActualizacion;
    }
    
    
    private  void initialize_connection(){
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conexion = DriverManager.getConnection(server, user, password);
            System.out.println("Conexión a base de datos " + server + " ... OK");
        } catch (ClassNotFoundException ex) {
            System.out.println("Error cargando el Driver MySQL JDBC ... FAIL");
        } catch (SQLException ex) {
            System.out.println("Imposible realizar conexion con " + server + " ... FAIL");
        }
        
    }
    
    private void close_connection(){
        try {
            conexion.close();
            System.out.println("Cerrar conexión con " + server + " ... OK");
        } catch (SQLException ex) {
            System.out.println("Imposible cerrar conexión ... FAIL");
        }
    }
    
    
    
    private Object[][] charge_clients_form(){
        Object[][] data = null;
        
        initialize_connection();
         
        // Realizar consulta
        try {
            // Preparamos la consulta
            Statement s = conexion.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_READ_ONLY
            );
            
            ResultSet rs = s.executeQuery("select * from cliente");
            
            rs.last(); // aqui movemos el cursor hasta el ultimo registro de la tabla, para obtener despues la cantidad de registros con getRow
            int numRows = rs.getRow();
            rs.beforeFirst(); //volvemos a poner el cursor al inicio
            
            data = new Object[numRows][6];
            // recorremos el resultado, mientras haya registros para leer, y escribimos el resultado en pantalla
            int row=0;
            while (rs.next()) {
                System.out.println( "cliente: " + rs.getInt(1) + "\tnombre: " + rs.getString(2) + "\tcorreo: " + rs.getString(3) + "\tdireccion: " + rs.getString(4) + "\tpuntos: " + rs.getInt(5) + "\ttipo" + rs.getString(6) );
                
                data[row][0] = rs.getInt(1); // ID Cliente
                data[row][1] = rs.getString(2); // Nombre
                data[row][2] = rs.getString(3); // Correo
                data[row][3] = rs.getString(4); // Dirección
                data[row][4] = rs.getInt(5);    // Puntos
                data[row][5] = rs.getString(6); // Tipo
                row++;
            }
        } catch (SQLException ex) {
            System.out.println("Imposible realizar consulta ... FAIL");
        }

        close_connection();
        
        return data;
    }
    
    
    private Object[][] charge_functions_form(){
        Object[][] data = null;
      
        initialize_connection();
         
        // Realizar consulta
        try {
            // Preparamos la consulta
            Statement s = conexion.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_READ_ONLY
            );
            
            ResultSet rs = s.executeQuery("select * from funcion");
            rs.last(); 
            int numRows = rs.getRow();
            rs.beforeFirst(); 
            data = new Object[numRows][8];
           
            int row=0;
            
            while (rs.next()) {
              
                data[row][0] = rs.getInt(1); 
                data[row][1] = rs.getString(2); 
                data[row][2] = rs.getString(3);
                data[row][3] = rs.getString(4);
                data[row][4] = rs.getTime(5);    
                data[row][5] = rs.getTime(6); 
                data[row][6] = rs.getTime(7); 
                data[row][7] = rs.getTimestamp(8); 
                
                row++;
            }
        } catch (SQLException ex) {
            System.out.println("Imposible realizar consulta ... FAIL");
        }

        close_connection();
        
        return data;
    }
    
    private void registrar_cliente(int id, String nombre, String correo, String direccion) {
    try {
        initialize_connection();

        String query = "{CALL sp_CrearCliente(?, ?, ?, ?)}";
        CallableStatement stmt = conexion.prepareCall(query);

        // Establece los valores para los parámetros del procedimiento
        stmt.setInt(1, id);           
        stmt.setString(2, nombre);     
        stmt.setString(3, correo);     
        stmt.setString(4, direccion);         

        stmt.executeUpdate();
        
        Object[][] datosClientes = charge_clients_form();
        actualizar_tabla(tablaClientes, datosClientes, columnasClientes);

        System.out.println("Cliente registrado exitosamente");

        close_connection();
    } catch (SQLException ex) {
        System.out.println("Imposible cerrar conexión ... FAIL");
    }
}
    
private void actualizar_cliente(int id, String campo, String nuevoValor) {
    try {
        initialize_connection();

        String query = "{CALL sp_ActualizarCliente(?, ?, ?)}";
        CallableStatement stmt = conexion.prepareCall(query);

        // Establece los valores para los parámetros del procedimiento
        stmt.setInt(1, id);           
        stmt.setString(2, campo);     
        stmt.setString(3, nuevoValor);              

        stmt.executeUpdate();
        
        Object[][] datosClientes = charge_clients_form();
        actualizar_tabla(tablaClientes, datosClientes, columnasClientes);

        System.out.println("Información actualizada exitosamente");

        close_connection();
    } catch (SQLException ex) {
        System.out.println("Imposible cerrar conexión ... FAIL");
    }
}
    
 private Object[][] posibles_beneficiarios(){
        Object[][] data = null;
        
        initialize_connection();
         
        // Realizar consulta
        try {
            // Preparamos la consulta
            Statement s = conexion.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_READ_ONLY
            );
            
            ResultSet rs = s.executeQuery("select * from vw_posiblesClientes ");
            
            rs.last(); // aqui movemos el cursor hasta el ultimo registro de la tabla, para obtener despues la cantidad de registros con getRow
            int numRows = rs.getRow();
            rs.beforeFirst(); //volvemos a poner el cursor al inicio
            
            data = new Object[numRows][4];
            // recorremos el resultado, mientras haya registros para leer, y escribimos el resultado en pantalla
            int row=0;
            while (rs.next()) {
                //System.out.println( "\tnombre: " + rs.getString(1) + "\tcorreo: " + rs.getString(2) + "\ttotal_compras: " + rs.getInt(3) + "\ttipo" + rs.getString(4) );
                
                data[row][0] = rs.getString(1); // Nombre
                data[row][1] = rs.getString(2); // Correo
                data[row][2] = rs.getInt(3);    // Total Compras
                data[row][3] = rs.getString(4); // Tipo_Membresía
                row++;
            }
        } catch (SQLException ex) {
            System.out.println("Imposible realizar consulta ... FAIL");
        }

        close_connection();
        
        return data;
    }
 
private void nueva_suscripcion(int id, String tipo) {
    try {
        initialize_connection();

        String query = "{CALL sp_CrearSuscripcion(?, ?)}";
        CallableStatement stmt = conexion.prepareCall(query);

        // Establecer los valores para los parámetros del procedimiento
        stmt.setInt(1, id);           
        stmt.setString(2, tipo);     

        // Ejecutar el procedimiento para crear la suscripción
        stmt.executeUpdate();
        
        Object[][] datosClientes = charge_clients_form();
        actualizar_tabla(tablaClientes, datosClientes, columnasClientes);

        System.out.println("Suscripción generada exitosamente");
        lblCliente.setText("¡Suscripción generada correctamente!");

        close_connection();

    } catch (SQLException ex) {
        try {
            // Si ya existe una suscripción, actualizar los datos
            String query = "{CALL sp_ActualizarSuscripcion(?, ?)}";
            CallableStatement stmt = conexion.prepareCall(query);

            // Establecer los valores para los parámetros del procedimiento
            stmt.setInt(1, id);           
            stmt.setString(2, tipo);     

            // Ejecutar el procedimiento de actualización
            stmt.executeUpdate();
        
            Object[][] datosClientes = charge_clients_form();
            actualizar_tabla(tablaClientes, datosClientes, columnasClientes);

            System.out.println("Información actualizada exitosamente");
            lblCliente.setText("El cliente ya contaba con una suscripción activa.");

            close_connection();
            
        } catch (SQLException e) {
            // Mostrar el error si la actualización falla
            System.out.println("Error al actualizar la suscripción: " + e.getMessage());
            lblCliente.setText("Error al intentar actualizar la suscripción.");
        }
    }
}

private void generar_boleta(int id, int id_empleado, String tipo, String medio, int cantidad, int funcion, int silla) {
    try {
        initialize_connection();
        
        String query = "{CALL  sp_RegistrarVentaYBoleta(?, ?, ?, ?, ?, ?, ?, ?, ?)}";
        CallableStatement stmt = conexion.prepareCall(query);

        // Establecer los valores para los parámetros del procedimiento
        stmt.setInt(1, id);           
        stmt.setInt(2, id_empleado);
        stmt.setString(3, tipo);
        stmt.setString(4, medio);           
        stmt.setInt(5, cantidad);
        stmt.setInt(6, 0);
        stmt.setInt(7, id);           
        stmt.setInt(8, funcion);
        stmt.setInt(9, silla);

        // Ejecutar el procedimiento para crear la suscripción
        stmt.executeUpdate();

        System.out.println("Boleta generada exitosamente");
        lblCliente.setText("¡Boleta generada correctamente!");
        
        String detalle = "Boleta Generada:\n" +
                    "ID Cliente: " + id + "\n" +
                    "Función: " + funcion + "\n" +
                    "Silla: " + silla + "\n" +
                    "Tipo de servicio: " + tipo + "\n" +
                    "Cantidad: " + cantidad + "\n" +
                    "ID Empleado en Taquilla: " + id_empleado + "\n" +
                    "Medio Pago: " + medio + "\n";
        textAreaDetalle.setText(detalle);

        close_connection();

    } catch (SQLException ex) {
            if ("45000".equals(ex.getSQLState())) {
                // Si la silla está reservada, mostrar el mensaje correspondiente
                textAreaDetalle.setText("La silla ya está reservada para esta función.");
            } else {
                // Mostrar otros errores generales
                textAreaDetalle.setText("ERROR: " + ex.getMessage());
            }
}
}

private void enargar_pedido(int id, String producto, int cantidad) {
    try {
        initialize_connection();
        
        String query = "{CALL sp_ProcesarPedido(?, ?, ?)}";
        CallableStatement stmt = conexion.prepareCall(query);

        // Establecer los valores para los parámetros del procedimiento
        stmt.setInt(1, id);           
        stmt.setString(2, producto);
        stmt.setInt(3, cantidad);

        // Ejecutar el procedimiento para crear la suscripción
        stmt.executeUpdate();

        System.out.println("Pedido procesado exitosamente");
        lblCliente.setText("¡Pedido procesado correctamente!");

        close_connection();

    } catch (SQLException ex) {
            } catch (NumberFormatException ex) {
            // Manejo de error si el ID no es un número válido
            lblCliente.setText("Por favor ingrese un ID válido.");
            } catch (Exception ex) {
                // Manejo general de excepciones
                lblCliente.setText("Ups! Algo salió mal, intente de nuevo");
            }
}

    private Object[][] charge_products_form(){
        Object[][] data = null;
      
        initialize_connection();
         
        // Realizar consulta
        try {
            // Preparamos la consulta
            Statement s = conexion.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_READ_ONLY
            );
            
            ResultSet rs = s.executeQuery("select * from alimento");
            rs.last(); 
            int numRows = rs.getRow();
            rs.beforeFirst(); 
            data = new Object[numRows][5];
           
            int row=0;
            
            while (rs.next()) {
              
                data[row][0] = rs.getString(1); 
                data[row][1] = rs.getString(2); 
                data[row][2] = rs.getInt(3);
                data[row][3] = rs.getString(4);
                data[row][4] = rs.getString(5);    
                    
                row++;
            }
        } catch (SQLException ex) {
            System.out.println("Imposible realizar consulta ... FAIL");
        }

        close_connection();
        
        
        
        return data;
    }
    
   
    
    private Object[][] chargue_data_home(){
        Object[][] data = null;
        initialize_connection();
        
        //aqui iria la logica de la funcion
        
        
        // Realizar consulta
        try {
            // Preparamos la consulta
            Statement s = conexion.createStatement(
                ResultSet.TYPE_SCROLL_INSENSITIVE, 
                ResultSet.CONCUR_READ_ONLY
            );
            
            ResultSet rs = s.executeQuery("select * from boletas_alimentos");
            rs.last(); 
            int numRows = rs.getRow();
            rs.beforeFirst(); 
            data = new Object[numRows][9];
           
            int row=0;
            
            while (rs.next()) {
              
                data[row][0] = rs.getInt(1); 
                data[row][1] = rs.getString(2); 
                data[row][2] = rs.getString(3);
                data[row][3] = rs.getInt(4);
                data[row][4] = rs.getInt(5);
                data[row][5] = rs.getInt(6);
                data[row][6] = rs.getInt(7);
                data[row][7] = rs.getString(8);
                data[row][8] = rs.getInt(9);
                    
                row++;
            }
        } catch (SQLException ex) {
            System.out.println("Imposible realizar consulta ... FAIL");
        }
        close_connection();


        return data;
    }
    
    public void actualizar_tabla(JTable tabla, Object[][] datosActualizados, String[] columnas) {
        DefaultTableModel modelo = new DefaultTableModel(datosActualizados, columnas);
        tabla.setModel(modelo);
    }
}