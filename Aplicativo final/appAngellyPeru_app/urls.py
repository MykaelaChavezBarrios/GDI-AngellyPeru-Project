from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('SelectCliente', views.select_cliente, name='SelectCliente'),
    path('SelectBolFact', views.select_bolfact, name='SelectBolFact'),
    path('SelectBolFactHist', views.select_historial, name='SelectBolFactHist'),

    path('Almacen', views.almacen, name='Almacen'),
    path('Almacen/InArt', views.insert_art, name='InArt'),
    path('Almacen/UpArt', views.update_art, name='UpdArt'),
    path('Almacen/UpArt/<str:codigo>', views.update_art, name='UpdArt'),

    path('Cliente_Natural', views.cliente_Natural, name='Cliente_Natural'),
    path('Cliente_Natural/InCliN', views.insert_cliN, name='InCliN'),
    path('Cliente_Natural/UpCliN', views.update_cliN, name='UpCliN'),
    path('Cliente_Natural/UpCliN/<str:codigo>',
         views.update_cliN, name='UpCliN'),

    path('Cliente_Juridico', views.cliente_Juridico, name='Cliente_Juridico'),
    path('Cliente_Juridico/InCliJ', views.insert_cliJ, name='InCliJ'),
    path('Cliente_Juridico/UpCliJ', views.update_cliJ, name='UpCliJ'),
    path('Cliente_Juridico/UpCliJ/<str:codigo>',
         views.update_cliJ, name='UpCliJ'),

    path('SelectTyCliN', views.select_newoldcliN, name='SelectTyCliN'),
    path('SelectTyCliN/InCliNnwe', views.cli_nuevoN,
         name='SelectTyCliN/InCliNnwe'),

    path('SelectTyCliJ', views.select_newoldcliJ, name='SelectTyCliJ'),
    path('SelectTyCliJ/InClijnwe', views.cli_nuevoJ,
         name='SelectTyCliJ/InClijnwe'),


    path('RegistrarBoleta', views.reg_Bol, name='RegistrarBoleta'),
    path('RegistrarBoleta/<str:cod_cliente>',
         views.reg_Bol, name='RegistrarBoleta'),
    path('RegistraBoleta', views.reg_bol2, name='RegistrarBoleta'),
    path('RegistraBoleta/<str:num>',
         views.reg_bol2, name='RegistraBoleta'),

    path('AgregarArt', views.buscar_art,
         name='AgregarArt'),
    path('AgregarArt/<str:num>', views.buscar_art,
         name='AgregarArt'),

    path('RegistrarFactura', views.reg_Fact, name='RegistrarFactura'),

    path('HistorialBoleta', views.boletas_historial, name="HistorialBoleta"),
    path('HistorialFactura', views.facturas_historial, name="HistorialFactura"),
    path('BoletaFinal', views.extend_boleta, name='BoletaFinal'),
    path('BoletaFinal/<str:codigo>', views.extend_boleta, name='BoletaFinal'),
    path('FacturaFinal', views.extend_factura, name='FacturaFinal'),
    path('FacturaFinal/<str:codigo>', views.extend_factura, name='FacturaFinal'),

    path('RegistrarBoleta/ClienteRegistrado', views.buscar_cn,
         name='RegistrarBoleta/ClienteRegistrado')


]
