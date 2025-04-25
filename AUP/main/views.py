from django.shortcuts import render
from .models import Historico, Tripulante, Patente, Base, Missao, Nave

def home(request):
    return render(request, 'home.html')

def tripulacao(request):
    tripulantes = Tripulante.objects.all().select_related('patente')
    return render(request, 'tripulacao.html', {'tripulantes': tripulantes})

def canony(request):
    naves = Nave.objects.all().prefetch_related('tripulante')
    return render(request, 'canony.html', {'naves': naves})

def historico_missoes(request):
    missoes = Missao.objects.all()
    return render(request, 'historico_missoes.html', {'missoes': missoes})

def patentes(request):
    patentes = Patente.objects.all()
    return render(request, 'patentes.html', {'patentes': patentes})

def eventos(request):
    eventos = Historico.objects.all().select_related('base', 'missao').order_by('-data')
    return render(request, 'eventos.html', {'eventos': eventos})

def monte_base(request):
    bases = Base.objects.all()
    return render(request, 'monte_base.html', {'bases': bases})
