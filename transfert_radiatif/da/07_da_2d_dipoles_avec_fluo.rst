DA 2D — Méthode des Dipôles avec Fluorescence
==============================================

Introduction
------------

On étend ici la résolution 2D par dipôles (voir :doc:`06_da_2d_dipoles_sans_fluo`)
au cas **fluorescent**. La source d'excitation est un faisceau collimaté ponctuel
$F_0\,e^{-\mu_{tx} z}\,\delta^{(2)}(\boldsymbol{\rho})$. Le terme source d'émission
comprend **deux contributions** : les photons diffus $\Phi_x$ et les photons balistiques
$F_0 e^{-\mu_{tx}z}$ qui peuvent tous deux exciter les fluorophores.

Système d'Équations de Diffusion 2D
--------------------------------------

**Excitation :**

$$-D_x\,\nabla^2\Phi_x + \mu_{ax}^\text{tot}\,\Phi_x
= F_0\,\mu_{sx}'\,e^{-\mu_{tx} z}\,\delta^{(2)}(\boldsymbol{\rho})$$

avec $\mu_{ax}^\text{tot} = \mu_{ax}+\mu_{af}$, $D_x = 1/[3\,\mu_{tx}]$,
$\delta_x = \sqrt{D_x/\mu_{ax}^\text{tot}}$, $z_{0x} = 1/\mu_{tx}$.

**Émission (CW) :**

$$-D_m\,\nabla^2\Phi_m + \mu_{am}\,\Phi_m
= \eta\,\mu_{af}\!\left[\Phi_x(\rho,z) + F_0\,e^{-\mu_{tx} z}\,\delta^{(2)}(\boldsymbol{\rho})\right]$$

avec $D_m = 1/[3(\mu_{am}+\mu_{sm}')]$, $\delta_m = \sqrt{D_m/\mu_{am}}$.

Le terme source comprend deux contributions :

- $\eta\,\mu_{af}\,\Phi_x(\rho,z)$ — excitation par les photons **diffus**
- $\eta\,\mu_{af}\,F_0\,e^{-\mu_{tx} z}\,\delta^{(2)}(\boldsymbol{\rho})$ — excitation par les photons **balistiques**

Résolution — Champ d'Excitation
---------------------------------

Par l'approximation dipôlaire $\mu_{tx}\,e^{-\mu_{tx} z'} \approx \delta(z'-z_{0x})$
(voir :doc:`06_da_2d_dipoles_sans_fluo`), la solution est :

.. math::

	\Phi_x(\rho,z) = \frac{F_0\,\mu_{sx}'}{4\pi D_x\,\mu_{tx}}\left[
	\frac{e^{-\rho_{x+}/\delta_x}}{\rho_{x+}} - \frac{e^{-\rho_{x-}/\delta_x}}{\rho_{x-}}
	\right]

avec $\rho_{x+} = \sqrt{\rho^2+(z-z_{0x})^2}$ et
$\rho_{x-} = \sqrt{\rho^2+(z+z_{0x}+2z_{bx})^2}$.

Résolution — Champ d'Émission
--------------------------------

Par linéarité, on décompose $\Phi_m = \Phi_m^\text{balist} + \Phi_m^\text{diff}$.

**Contribution balistique** $\Phi_m^\text{balist}$
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Le terme source $\eta\,\mu_{af}\,F_0\,e^{-\mu_{tx} z}\,\delta^{(2)}(\boldsymbol{\rho})$
est une source axiale exponentielle. Par l'approximation dipôlaire en $z_{0x}$,
propagée dans le milieu d'émission ($\delta_m$, $z_{bm}$) :

.. math::

	\Phi_m^\text{balist}(\rho,z) = \frac{\eta\,\mu_{af}\,F_0}{4\pi D_m\,\mu_{tx}}\left[
	\frac{e^{-\rho_{m+}/\delta_m}}{\rho_{m+}} - \frac{e^{-\rho_{m-}/\delta_m}}{\rho_{m-}}
	\right]

avec $\rho_{m+} = \sqrt{\rho^2+(z-z_{0x})^2}$ et
$\rho_{m-} = \sqrt{\rho^2+(z+z_{0x}+2z_{bm})^2}$.

.. note::

   $\Phi_m^\text{balist}$ et $\Phi_x$ ont la même source géométrique ($z_{0x}$),
   mais se propagent avec les propriétés optiques du milieu d'**émission**
   ($\delta_m$, $z_{bm}$) et non d'excitation.

**Contribution diffuse** $\Phi_m^\text{diff}$
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

L'émission de fluorescence étant **isotrope**, chaque point source
$(\rho_0,z_0)$ rayonne de façon égale dans toutes les directions : le terme
source de l'équation d'émission est un **scalaire** sans dépendance angulaire.
Combiné à la symétrie cylindrique de la géométrie, cela permet d'écrire
directement la Green en coordonnées cylindriques $(\rho,z)$.

Fonction de Green cylindrique $\mathcal{G}_m$
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La Green cylindrique $\mathcal{G}_m(\rho,z;\rho_0,z_0)$ est la solution de
l'équation de diffusion azimutalement symétrique avec source annulaire unitaire
en $(\rho_0,z_0)$ :

.. math::

	-D_m\left[\frac{1}{\rho}\frac{\partial}{\partial\rho}
	\left(\rho\frac{\partial\mathcal{G}_m}{\partial\rho}\right)
	+\frac{\partial^2\mathcal{G}_m}{\partial z^2}\right]
	+\mu_{am}\,\mathcal{G}_m
	= \frac{\delta(\rho-\rho_0)\,\delta(z-z_0)}{\rho_0}

avec la condition aux limites extrapolée $\mathcal{G}_m(\rho,-z_{bm};\rho_0,z_0)=0$.

.. note::

	Le facteur $1/\rho_0$ au membre de droite provient de la forme de la mesure
	en coordonnées cylindriques : une source annulaire de puissance unitaire en
	$(\rho_0,z_0)$ s'écrit $\delta(\rho-\rho_0)\delta(z-z_0)/(2\pi\rho_0)$
	intégrée sur $2\pi$ en $\phi$.

Par la transformée de Hankel d'ordre 0 en $\rho$ (qui diagonalise l'opérateur
$\frac{1}{\rho}\partial_\rho(\rho\partial_\rho)$), $\mathcal{G}_m$ admet la
représentation :

.. math::

	\mathcal{G}_m(\rho,z;\rho_0,z_0)
	= \int_0^\infty \tilde{G}_m(s_r,z;z_0)\,
	  J_0(s_r\rho)\,J_0(s_r\rho_0)\,s_r\,ds_r

$$\tilde{G}_m(s_r,z;z_0)
= \frac{e^{-\alpha_m|z-z_0|}-e^{-\alpha_m(z+z_0+2z_{bm})}}{2\alpha_m D_m},
\qquad \alpha_m = \sqrt{s_r^2+\frac{1}{\delta_m^2}}$$

Intégrale de convolution cylindrique
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

La solution s'écrit alors comme une convolution dans le demi-plan $(\rho,z)$ :

.. math::

	\Phi_m^\text{diff}(\rho,z) = \eta\,\mu_{af}
	\int_0^\infty\!\!\int_0^\infty
	\mathcal{G}_m(\rho,z;\rho_0,z_0)\,\Phi_x(\rho_0,z_0)\,\rho_0\,d\rho_0\,dz_0

.. solution::

	En substituant la représentation de Hankel de $\mathcal{G}_m$ et en
	intervertissant les intégrations (Fubini) :

	$$\Phi_m^\text{diff}(\rho,z) = \eta\,\mu_{af}
	\int_0^\infty \left[
	\int_0^\infty \tilde{G}_m(s_r,z;z_0)
	\underbrace{\int_0^\infty \Phi_x(\rho_0,z_0)\,J_0(s_r\rho_0)\,\rho_0\,d\rho_0}_{=\;\tilde{\Phi}_x(s_r,z_0)}
	dz_0\right] J_0(s_r\rho)\,s_r\,ds_r$$

	On reconnaît la transformée de Hankel inverse de $\tilde{\Phi}_m^\text{diff}$.

**Résultat dans l'espace de Fourier–Hankel :**

.. math::

	\boxed{
	\tilde{\Phi}_m^\text{diff}(s_r,z)
	= \frac{\eta\,\mu_{af}}{D_m}\int_0^\infty
	  \tilde{G}_m(s_r,z;z_0)\,\tilde{\Phi}_x(s_r,z_0)\,dz_0
	}

$\tilde{\Phi}_x(s_r,z_0)$ est la transformée de Hankel de $\Phi_x(\cdot,z_0)$,
donnée par :doc:`08_da_2d_kienle_sans_fluo`. Cette intégrale 1D en $z_0$ est
calculée **analytiquement** dans la méthode de Kienle
(:doc:`09_da_2d_kienle_avec_fluo`). Le retour en espace réel s'effectue par
transformée de Hankel inverse :

$$\Phi_m^\text{diff}(\rho,z)
= \int_0^\infty \tilde{\Phi}_m^\text{diff}(s_r,z)\,J_0(s_r\rho)\,s_r\,ds_r$$


Solution Totale
~~~~~~~~~~~~~~~~

.. math::

	\boxed{\Phi_m(\rho,z) = \Phi_m^\text{balist}(\rho,z) + \Phi_m^\text{diff}(\rho,z)}

Réflectance de Fluorescence en $z = 0$
----------------------------------------

La réflectance (flux sortant en $-z$) est :

$$R_m(\rho) = D_m\,\frac{\partial\Phi_m}{\partial z}\bigg|_{z=0}
= R_m^\text{balist}(\rho) + R_m^\text{diff}(\rho)$$

car $\partial_z\Phi_m|_{z=0} > 0$ (la fluence croît de la surface vers la source).

Noyau de réflectance cylindrique $\mathcal{K}_m$
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

En passant la dérivée sous l'intégrale de convolution :

$$R_m^\text{diff}(\rho) = \eta\,\mu_{af}
\int_0^\infty\!\!\int_0^\infty
\underbrace{D_m\frac{\partial\mathcal{G}_m}{\partial z}\bigg|_{z=0}}_{\mathcal{K}_m(\rho\,;\rho_0,z_0)}
\Phi_x(\rho_0,z_0)\,\rho_0\,d\rho_0\,dz_0$$

Le noyau $\mathcal{K}_m$ est la dérivée en $z=0$ de la Green cylindrique.
En dérivant terme à terme l'intégrale azimutale de $\mathcal{G}_m$, avec

$$\frac{\partial R_+}{\partial z}\bigg|_{z=0}
= \frac{z - z_0}{R_+}\bigg|_{z=0} = \frac{-z_0}{R_+}, \qquad
\frac{\partial R_-}{\partial z}\bigg|_{z=0}
= \frac{z + z_0 + 2z_{bm}}{R_-}\bigg|_{z=0} = \frac{z_0+2z_{bm}}{R_-}$$

et $\dfrac{\partial}{\partial z}\dfrac{e^{-R/\delta}}{R} = \dfrac{\partial R}{\partial z}\left(-\dfrac{1}{\delta R}-\dfrac{1}{R^2}\right)e^{-R/\delta}$, on obtient :

.. math::

	\mathcal{K}_m(\rho\,;\rho_0,z_0)
	= \frac{1}{4\pi}\int_0^{2\pi}
	\left[
	  \frac{z_0\left(1+R_+/\delta_m\right)}{R_+^3}\,e^{-R_+/\delta_m}
	+ \frac{(z_0+2z_{bm})\left(1+R_-/\delta_m\right)}{R_-^3}\,e^{-R_-/\delta_m}
	\right]d\phi_0

avec les distances source–observation en $z=0$ :

$$R_+ = \sqrt{\rho^2+\rho_0^2-2\rho\rho_0\cos\phi_0+z_0^2}$$
$$R_- = \sqrt{\rho^2+\rho_0^2-2\rho\rho_0\cos\phi_0+(z_0+2z_{bm})^2}$$

L'intégrale azimutale sur $\phi_0$ ne se simplifie pas en général
(intégrales elliptiques pour $\rho_0\neq 0$) ; elle est évaluée numériquement.

.. note::

   Pour $\rho_0=0$ (source sur l'axe), $R_\pm$ est indépendant de $\phi_0$
   et l'intégrale donne $2\pi$, ce qui redonne exactement le noyau
   de $R_m^\text{balist}$ ci-dessous.

Réflectance balistique
~~~~~~~~~~~~~~~~~~~~~~~

La source balistique est sur l'axe ($\rho_0=0$, $z_0=z_{0x}$),
l'intégrale azimutale vaut $2\pi$ et on applique
l'approximation $\mu_{tx}\,e^{-\mu_{tx}z_0}\approx\delta(z_0-z_{0x})$ :

.. math::

	\boxed{R_m^\text{balist}(\rho)
	= \frac{\eta\,\mu_{af}\,F_0}{4\pi\,\mu_{tx}}
	\left[
	  \frac{z_{0x}\left(1+\rho_{m+}/\delta_m\right)}{\rho_{m+}^3}\,e^{-\rho_{m+}/\delta_m}
	+ \frac{(z_{0x}+2z_{bm})\left(1+\rho_{m-}/\delta_m\right)}{\rho_{m-}^3}\,e^{-\rho_{m-}/\delta_m}
	\right]}

avec $\rho_{m+} = \sqrt{\rho^2+z_{0x}^2}$,
$\rho_{m-} = \sqrt{\rho^2+(z_{0x}+2z_{bm})^2}$.

Réflectance diffuse
~~~~~~~~~~~~~~~~~~~~

La réflectance diffuse complète est une **double intégrale en espace réel** :

.. math::

	\boxed{
	R_m^\text{diff}(\rho)
	= \frac{\eta\,\mu_{af}}{4\pi}
	\int_0^\infty\!\!\int_0^\infty
	\Phi_x(\rho_0,z_0)
	\int_0^{2\pi}\!\!
	\left[
	  \frac{z_0(1+R_+/\delta_m)}{R_+^3}e^{-R_+/\delta_m}
	+ \frac{(z_0+2z_{bm})(1+R_-/\delta_m)}{R_-^3}e^{-R_-/\delta_m}
	\right]
	d\phi_0\;\rho_0\,d\rho_0\,dz_0
	}

$\Phi_x(\rho_0,z_0)$ est donné par :eq:`phi_x`. La réflectance totale est :

.. math::

	R_m(\rho) = R_m^\text{balist}(\rho) + R_m^\text{diff}(\rho)

C'est la grandeur inversée en FDOT pour reconstruire $\mu_{af}(\rho_0,z_0)$.

Extension Temporelle
---------------------

En régime temporel, l'équation d'émission devient :

$$\frac{1}{c}\partial_t\Phi_m - D_m\nabla^2\Phi_m + \mu_{am}\Phi_m
= \frac{\eta\,\mu_{af}}{\tau_f}\int_{-\infty}^{t}e^{-(t-t')/\tau_f}
\!\left[\Phi_x(\rho,z,t') + F_0\,e^{-\mu_{tx} z}\,\delta(t')\,\delta^{(2)}(\boldsymbol{\rho})\right]dt'$$

En domaine de Laplace ($s = j\omega$), le terme source devient
$\frac{\eta\,\mu_{af}}{1+s\tau_f}\!\left[\tilde\Phi_x + F_0\,e^{-\mu_{tx}z}\,\delta^{(2)}\right]$,
et l'on remplace $\mu_a \leftarrow \mu_a + s/c$ dans chaque équation.

.. seealso::

   :doc:`05_da_1d_dipoles_avec_fluo` — cas 1D fluorescent plus simple.

   :doc:`06_da_2d_dipoles_sans_fluo` — cas 2D sans fluorescence.

   :doc:`09_da_2d_kienle_avec_fluo` — résolution analytique fermée via fréquences spatiales.