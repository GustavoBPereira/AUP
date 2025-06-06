from django.shortcuts import render
from .models import Historico, Tripulante, Patente, Base, Missao, Nave
from django.db.models import Case, When, Value, IntegerField

def home(request):
    return render(request, 'home.html')

def tripulacao(request):
    ordem_personalizada = Case(
        When(patente__nome='Almirante', then=Value(1)),
        When(patente__nome='Vice Almirante', then=Value(2)),
        When(patente__nome='Contra Almirante', then=Value(3)),
        When(patente__nome='Comodoro', then=Value(4)),
        When(patente__nome='Capitão', then=Value(5)),
        When(patente__nome='Tenente Comandante', then=Value(6)),
        When(patente__nome='Tenente', then=Value(7)),
        When(patente__nome='Tenente Júnior', then=Value(8)),
        When(patente__nome='Alferes', then=Value(9)),
        When(patente__nome='Cadete', then=Value(10)),
        default=Value(99),  # Qualquer outro cargo vai no fim
        output_field=IntegerField()
    )

    tripulantes = Tripulante.objects.annotate(ordem=ordem_personalizada).order_by('ordem').select_related('patente')
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
