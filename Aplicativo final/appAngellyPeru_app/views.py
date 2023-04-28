from django.shortcuts import render, redirect
from django.db import connection

bd_cursor = connection.cursor()

# --Extras--#


def home(request):
    return render(request, 'Extras/home.html')


def select_cliente(request):
    return render(request, 'Extras/sel_cli.html')


def select_bolfact(request):
    return render(request, 'Extras/sel_bf_reg.html')


def select_newoldcliN(request):
    return render(request, 'Cliente_Natural/newold.html')


def select_newoldcliJ(request):
    return render(request, 'Cliente_Juridico/newold.html')


def select_historial(request):
    return render(request, 'Extras/sel_bf_his.html')


# --Manejo Articulos--#

def almacen(request):
    bd_cursor.execute('call sp_datos_articulos()')
    tabla = bd_cursor.fetchall()
    return render(request, 'Articulo/index.html', {'tabla': tabla})

# --insertar articulo--#


def insert_art(request):
    if request.method == 'POST':
        if request.POST.get('cod_art') and request.POST.get('des_art') and request.POST.get('pre_art') and request.POST.get('emp_art') and request.POST.get('med_art') and request.POST.get('sto_art'):
            cod = request.POST.get('cod_art')
            des = request.POST.get('des_art')
            pre = request.POST.get('pre_art')
            emp = request.POST.get('emp_art')
            med = request.POST.get('med_art')
            sto = request.POST.get('sto_art')
            bd_cursor.execute("call sp_inserta_articulo('"+cod +
                              "','"+des+"','"+pre+"','"+emp+"','"+med+"','"+sto+"')")
            return redirect('Almacen')

    return render(request, 'Articulo/form.html')

# --actualizar articulo--#


def update_art(request, codigo):
    bd_cursor.execute("call sp_busca_articulo_codigo('"+codigo+"')")
    tabla = bd_cursor.fetchall()
    if request.method == "POST":
        if request.POST.get('cod_art') and request.POST.get('des_art') and request.POST.get('pre_art') and request.POST.get('emp_art') and request.POST.get('med_art') and request.POST.get('sto_art'):
            cod = request.POST.get('cod_art')
            des = request.POST.get('des_art')
            pre = request.POST.get('pre_art')
            emp = request.POST.get('emp_art')
            med = request.POST.get('med_art')
            sto = request.POST.get('sto_art')
        bd_cursor.execute("call sp_actualiza_articulo('"+cod +
                          "','"+des+"','"+pre+"','"+emp+"','"+med+"','"+sto+"')")
        return redirect('Almacen')

    return render(request, 'Articulo/form.html', {'tabla': tabla})

# --Manejo Clientes Naturales--#


def cliente_Natural(request):
    bd_cursor.execute('call sp_datos_clientesn()')
    tabla = bd_cursor.fetchall()
    return render(request, 'Cliente_Natural/index.html', {'tabla': tabla})

# --insertar Cliente Natural--#


def insert_cliN(request):
    if request.method == 'POST':
        if request.POST.get('dni') and request.POST.get('nom') and request.POST.get('ape') and request.POST.get('dir'):
            dni = request.POST.get('dni')
            nom = request.POST.get('nom')
            ape = request.POST.get('ape')
            dir = request.POST.get('dir')
            bd_cursor.execute("call sp_inserta_clienten('"+dni +
                              "','"+nom+"','"+ape+"','"+dir+"')")
            return redirect('Cliente_Natural')

    return render(request, 'Cliente_Natural/form.html')

# --actualizar Cliente Natural--#


def update_cliN(request, codigo):
    bd_cursor.execute("call sp_busca_clienten_dni('"+codigo+"')")
    tabla = bd_cursor.fetchall()
    if request.method == "POST":
        if request.POST.get('dni') and request.POST.get('nom') and request.POST.get('ape') and request.POST.get('dir'):
            dni = request.POST.get('dni')
            nom = request.POST.get('nom')
            ape = request.POST.get('ape')
            dir = request.POST.get('dir')
        bd_cursor.execute("call sp_actualiza_clienten('" + dni +
                          "','"+nom+"','"+ape+"','"+dir+"')")
        return redirect('Cliente_Natural')

    return render(request, 'Cliente_Natural/form.html', {'tabla': tabla})


# --Manejo Clientes Juridicos--#


def cliente_Juridico(request):
    bd_cursor.execute('call sp_datos_clientesj()')
    tabla = bd_cursor.fetchall()
    return render(request, 'Cliente_Juridico/index.html', {'tabla': tabla})

# --insertar Cliente Juridico--#


def insert_cliJ(request):
    if request.method == 'POST':
        if request.POST.get('ruc') and request.POST.get('rzs') and request.POST.get('dif'):
            ruc = request.POST.get('ruc')
            rzs = request.POST.get('rzs')
            dif = request.POST.get('dif')
            bd_cursor.execute("call sp_inserta_clientej('" +
                              ruc+"','"+rzs+"','"+dif+"')")
            return redirect('Cliente_Juridico')

    return render(request, 'Cliente_Juridico/form.html')


# --actualizar Cliente Juridico--#

def update_cliJ(request, codigo):
    bd_cursor.execute("call sp_busca_clientej_ruc('"+codigo+"')")
    tabla = bd_cursor.fetchall()
    if request.method == "POST":
        if request.POST.get('ruc') and request.POST.get('rzs') and request.POST.get('dif'):
            ruc = request.POST.get('ruc')
            rzs = request.POST.get('rzs')
            dif = request.POST.get('dif')
        bd_cursor.execute("call sp_actualiza_clientej('" + ruc +
                          "','"+rzs+"','"+dif+"')")
        return redirect('Cliente_Juridico')

    return render(request, 'Cliente_Juridico/form.html', {'tabla': tabla})

# --Registrar Boleta--#


def cli_nuevoN(request):
    if request.method == 'POST':
        if request.POST.get('dni') and request.POST.get('nom') and request.POST.get('ape') and request.POST.get('dir'):
            dni = request.POST.get('dni')
            nom = request.POST.get('nom')
            ape = request.POST.get('ape')
            dir = request.POST.get('dir')
            bd_cursor.execute("call sp_inserta_clienten('"+dni +
                              "','"+nom+"','"+ape+"','"+dir+"')")
            return redirect('RegistrarBoleta', dni)

    return render(request, 'Cliente_Natural/form_new.html')


def cli_nuevoJ(request):
    if request.method == 'POST':
        if request.POST.get('ruc') and request.POST.get('rzs') and request.POST.get('dif'):
            ruc = request.POST.get('ruc')
            rzs = request.POST.get('rzs')
            dif = request.POST.get('dif')
            bd_cursor.execute("call sp_inserta_clientej('" +
                              ruc+"','"+rzs+"','"+dif+"')")
            return redirect('RegistrarFactura')

    return render(request, 'Cliente_Juridico/form_new.html')


def reg_Bol(request, cod_cliente):
    bd_cursor.execute("call sp_busca_clienten_dni('"+cod_cliente+"')")
    cliente_tabla = bd_cursor.fetchall()
    if request.method == "POST":
        if request.POST.get('dia') and request.POST.get('mes') and request.POST.get('anio') and request.POST.get('num'):
            dia = request.POST.get('dia')
            mes = request.POST.get('mes')
            anio = request.POST.get('anio')
            num = request.POST.get('num')
            bd_cursor.execute("call sp_boleta_cabecera_in('"+num +
                              "','"+dia+"','"+mes+"','"+anio+"','"+cod_cliente+"')")
            return redirect('RegistraBoleta', num)

    return render(request, 'Boleta/regis.html', {'cliente_tabla': cliente_tabla})


def reg_bol2(request, num):
    bd_cursor.execute("call sp_boleta_cabecera_mostrar('"+num+"')")
    boleta_cabecera = bd_cursor.fetchall()
    bd_cursor.execute("call sp_detalle_boleta_fin('"+num+"')")
    boleta_cuerpo = bd_cursor.fetchall()
    bd_cursor.execute("call sp_boleta_pie('"+num+"')")
    boleta_pie = bd_cursor.fetchall()
    return render(request, 'Boleta/regis2.html', {'boleta_cabecera': boleta_cabecera, 'boleta_cuerpo': boleta_cuerpo, 'boleta_pie': boleta_pie})


def buscar_art(request, num):
    cod_art = request.GET.get("cod_art")
    if cod_art:
        str(cod_art)
        bd_cursor.execute("call sp_busca_articulo_codigo('"+cod_art+"')")
        tabla = bd_cursor.fetchall()
        if request.method == 'POST':
            if request.POST.get('cant') and request.POST.get('desc'):
                cant = request.POST.get('cant')
                desc = request.POST.get('desc')
                bd_cursor.execute(
                    "call sp_inserta_articant_B('"+num+"','"+cod_art+"','"+cant+"', '"+desc+"')")
            return redirect('RegistraBoleta', num)
        return render(request, 'Articulo/elegir.html', {'tabla': tabla})
    else:
        return render(request, 'Articulo/elegir.html')


def reg_Fact(request):
    return render(request, 'Factura/regis.html')

# --historial Boletas--#


def boletas_historial(request):
    bd_cursor.execute('call sp_listar_boleta()')
    tabla = bd_cursor.fetchall()
    return render(request, 'Boleta/historial.html', {'tabla': tabla})


def facturas_historial(request):
    bd_cursor.execute('call sp_listar_factura()')
    tabla = bd_cursor.fetchall()
    return render(request, 'Factura/historial.html', {'tabla': tabla})


def det_bol(request, codigo, codigo2):
    bd_cursor.execute(
        "call sp_detalle_boleta_fin('"+codigo+"', '"+codigo2+"')")
    tabla2 = bd_cursor.fetchall()
    return render(request, 'Boleta/extend.html', {'tabla2': tabla2})


def extend_boleta(request, codigo):
    bd_cursor.execute("call sp_boleta_cabecera_mostrar('"+codigo+"')")
    boleta_cabecera = bd_cursor.fetchall()
    bd_cursor.execute("call sp_detalle_boleta_fin('"+codigo+"')")
    boleta_cuerpo = bd_cursor.fetchall()
    bd_cursor.execute("call sp_boleta_pie('"+codigo+"')")
    boleta_pie = bd_cursor.fetchall()
    return render(request, 'Boleta/extend.html', {'boleta_cabecera': boleta_cabecera, 'boleta_cuerpo': boleta_cuerpo, 'boleta_pie': boleta_pie})


def extend_boleta2(request, codigo):
    bd_cursor.execute("call sp_detallar_boleta('"+codigo+"')")
    tabla = bd_cursor.fetchall()
    bd_cursor.execute("call sp_art_detalle('"+codigo+"')")
    tabla2 = bd_cursor.fetchall()
    for cod in tabla2:
        cod2 = str(cod(0))
        det_bol(request, codigo, cod2)

    return render(request, 'Boleta/extend.html', {'tabla': tabla})


def det_fact(request, codigo, codigo2):
    bd_cursor.execute(
        "call sp_detalle_factura_fin('"+codigo+"', '"+codigo2+"')")
    tabla2 = bd_cursor.fetchall()
    return render(request, 'Factura/extend.html', {'tabla2': tabla2})


def extend_factura(request, codigo):
    bd_cursor.execute("call sp_detallar_factura('"+codigo+"')")
    tabla = bd_cursor.fetchall()
    return render(request, 'Factura/extend.html', {'tabla': tabla})


def extend_factura2(request, codigo):
    bd_cursor.execute("call sp_detallar_factura('"+codigo+"')")
    tabla = bd_cursor.fetchall()
    bd_cursor.execute("call sp_art_detallef('"+codigo+"')")
    tabla2 = bd_cursor.fetchall()
    for cod in tabla2:
        cod2 = str(cod(0))
        det_fact(request, codigo, cod2)

    return render(request, 'Factura/extend.html', {'tabla': tabla})


def buscar_cn(request, dni):
    if request.method == "GET":
        if request.POST.get('dni'):
            dni = request.POST.get('dni')
            bd_cursor.execute("call sp_busca_clienten_dni('"+dni+"')")
            tabla = bd_cursor.fetchall()
    return render({'tabla': tabla})


def buscador_cn(request):
    bd_cursor.execute('call sp_listar_boleta()')
    tabla = bd_cursor.fetchall()
    buscar_cn("'+{tabla.0.0}+'")
    return render(request, 'Cliente_Natural/registrado.html', {'tabla': tabla})
