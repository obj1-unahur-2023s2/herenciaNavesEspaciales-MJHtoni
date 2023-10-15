class Nave {
	var velocidad
	var direccion
	var combustible
	
	method acelerar(cuanto) {
		velocidad += 100000.min(cuanto)
		}
	method desacelerar(cuanto) {
		velocidad -= 0.max(cuanto)
	}
	method irHaciaElSol() {
		direccion = 10
	}
	method escaparDelSol() {
		direccion = -10
	}
	method ponerseParaleloAlSol() {
		direccion = 0
	}
	method acercarseUnPocoAlSol(){
		direccion = 10.min(direccion+1)
	}
	method alejarseUnPocoDelSol(){
		direccion = (-10).max(direccion-1)
	}
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	method cargarCombustible(carga) {
		combustible += carga
	}
	method descargarCombustible(carga) {
		combustible = 0.max(combustible-carga)
	}
	method estaTranquila() {
		return combustible >= 4000 and velocidad <= 12000
	}
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	method estaDeRelajo(){
		return self.estaTranquila() and self.tienePocaActividad()
	}
	method tienePocaActividad()
}

class NavesBaliza inherits Nave {
	var color
	var cambiosDeColor = 0
	
	method cambiarColorDeBaliza(colorNuevo) {
		color = colorNuevo
		cambiosDeColor ++
	}
	override method prepararViaje(){
		super()
		self.cambiarColorDeBaliza("Verde")
		self.ponerseParaleloAlSol()
	}
	override method estaTranquila() {
		return super() and color != "Rojo"
	}
	method escapar() {
		self.irHaciaElSol()
	}
	method avisar() {
		self.cambiarColorDeBaliza("Rojo")
	}
	override method tienePocaActividad() {
		return cambiosDeColor == 0
	}
}

class NavesPasajeros inherits Nave {
	var pasajeros
	var comida
	var comidaDada
	var bebida
	
	method cargarComida(cantidad) {
		comida += cantidad
	}
	method cargarBebida(cantidad) {
		bebida += cantidad
	}
	method descargarComida(cantidad) {
		comida = 0.max(comida-cantidad)
		comidaDada ++
	}
	method descargarBebida(cantidad) {
		comida = 0.max(bebida-cantidad)
	}
	override method prepararViaje() {
		super()
		self.cargarComida(4*pasajeros)
		self.cargarBebida(6*pasajeros)
		self.acercarseUnPocoAlSol()
	}
	method escapar() {
		velocidad *= 2
	}
	method avisar() {
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros*2)
	}
	override method tienePocaActividad() {
		return comidaDada < 50
	}
}

class NavesCombate inherits Nave {
	var property estaInvisible
	var property misilesDesplegados
	const mensajes = []
	
	method ponerseVisible() {
		estaInvisible = false
	}
	method ponerseInvisible() {
		estaInvisible = true
	}
	method desplegarMisiles() {
		misilesDesplegados = true
	}
	method replegarMisiles() {
		misilesDesplegados = false
	}
	method emitirMensaje(mensaje) = mensajes.add(mensaje)
	method mensajesEmitidos() = mensajes.size()
	method primerMensajeEmitido() = mensajes.first()
	method ultimoMensajeEmitido() = mensajes.last()
	method esEscueta() = mensajes.all({m =>m.length()<=30})
	method emitioMensaje(mensaje) = mensajes.find({m => m == mensaje})
	override method prepararViaje() {
		super()
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method estaTranquila() {
		return super() and not self.misilesDesplegados()
	}
	method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	method avisar() {
		return self.emitirMensaje("Amenaza recibida")
	}
	override method tienePocaActividad() {
		return self.esEscueta()
	}
}

class NavesHospital inherits NavesPasajeros {
	var property quirofanoPreparado
	
	override method estaTranquila() {
		return super() and not self.quirofanoPreparado()
	}
	override method recibirAmenaza() {
		super()
		quirofanoPreparado = true
	}
}

class NavesCombateSigilosa inherits NavesCombate {
	override method estaTranquila() {
		return super() and not self.estaInvisible()
	}
	override method recibirAmenaza() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}