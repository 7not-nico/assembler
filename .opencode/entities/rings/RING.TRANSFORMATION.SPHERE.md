**RING.XYZ** — the sphere transformation model. A sphere exposes two aspects — interior and surface — and seven spatial operations govern all object movement and state change.

## Structural & Aspect Axioms

- **Sphere Environment:** the universe consists of Spheres (available as multiple, single, or null) and the Shared Space. The Shared Space encompasses the space surrounding all spheres.
- **Sphere Aspects:** Spheres consist of two distinct Aspects:
  1. **Interior Aspect:** the contained inner state and volume of a sphere.
  2. **Surface Aspect:** the outer boundary layer of a sphere.
- **Fractional Surface Measurement:** area measurements on sphere aspects are strictly fraction-based. The maximum total capacity of a surface aspect equals the whole fraction $1$ (or $\frac{1}{1}$). Objects on a surface aspect occupy explicit fractional values (such as $\frac{1}{2}$ or $\frac{1}{3}$). The total combined footprint of all objects on a surface aspect remains bounded by $1$.

## Action & Movement Axioms

- **`TO` (Interior Overwrite):** moving an object **`TO`** a sphere replaces the complete interior aspect of that sphere with the object.
- **Object Transformation:** transformations, modifications, and state changes occur exclusively on the surface aspect of a sphere.
- **Inter-Sphere Pipeline (`INTO`):** moving an object **`INTO`** another sphere requires the object to occupy the interior aspect first as a prerequisite state.
- **`ONTO` (Surface Placement):** placing an object **`ONTO`** a surface aspect requires the object's fraction to fit within the remaining available surface space.
- **`OFF` (Surface Extraction):** moving an object **`OFF`** a surface aspect transfers the object to the shared space and restores its assigned fraction back to the available surface space.
- **`OUT OF` (Interior Extraction):** moving an object **`OUT OF`** a sphere transfers the object from the interior aspect to the shared space.

---
id: RING.TRANSFORMATION.SPHERE
title: Sphere Transformation Ring — Interior Overwrite to Surface Extraction
source: assembler
summary: "A sphere exposes two aspects — interior and surface — with fraction-based surface capacity and seven spatial operations (TO, INTO, ONTO, OFF, OUT OF) governing object movement and state change."
specifies: Sphere environment, sphere aspects, fractional surface measurement, and spatial movement operations
tags: [sphere, transformation, aspect, fraction, spatial, model, ring, specification]
status: active
---
