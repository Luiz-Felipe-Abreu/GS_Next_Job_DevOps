/**
 * NextJob - JavaScript Application
 * Funções auxiliares e utilitários para integração com API REST
 */

// Configuração base da API
const API_BASE_URL = '/api';

/**
 * Utilitário para fazer requisições HTTP
 */
const httpClient = {
    async get(url) {
        const response = await fetch(url);
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    },

    async post(url, data) {
        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    },

    async put(url, data) {
        const response = await fetch(url, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(data)
        });
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return await response.json();
    },

    async delete(url) {
        const response = await fetch(url, {
            method: 'DELETE'
        });
        if (!response.ok && response.status !== 204) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.status === 204 ? null : await response.json();
    }
};

/**
 * API de Candidatos
 */
const candidatesAPI = {
    async getAll() {
        return await httpClient.get(`${API_BASE_URL}/candidates`);
    },

    async getById(id) {
        return await httpClient.get(`${API_BASE_URL}/candidates/${id}`);
    },

    async create(candidate) {
        return await httpClient.post(`${API_BASE_URL}/candidates`, candidate);
    },

    async update(id, candidate) {
        return await httpClient.put(`${API_BASE_URL}/candidates/${id}`, candidate);
    },

    async delete(id) {
        return await httpClient.delete(`${API_BASE_URL}/candidates/${id}`);
    }
};

/**
 * API de Vagas
 */
const vacanciesAPI = {
    async getAll() {
        return await httpClient.get(`${API_BASE_URL}/vacancies`);
    },

    async getById(id) {
        return await httpClient.get(`${API_BASE_URL}/vacancies/${id}`);
    },

    async create(vacancy) {
        return await httpClient.post(`${API_BASE_URL}/vacancies`, vacancy);
    },

    async update(id, vacancy) {
        return await httpClient.put(`${API_BASE_URL}/vacancies/${id}`, vacancy);
    },

    async delete(id) {
        return await httpClient.delete(`${API_BASE_URL}/vacancies/${id}`);
    }
};

/**
 * API de Match/Compatibilidade
 */
const matchAPI = {
    async calculateCompatibility(candidateId, vacancyId) {
        return await httpClient.post(`${API_BASE_URL}/match/compatibility`, {
            candidateId: candidateId,
            vacancyId: vacancyId
        });
    }
};

/**
 * Utilitários de UI
 */
const ui = {
    showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.className = `${type}-notification`;
        notification.textContent = message;
        notification.style.position = 'fixed';
        notification.style.top = '80px';
        notification.style.right = '20px';
        notification.style.padding = '1rem 1.5rem';
        notification.style.borderRadius = '5px';
        notification.style.boxShadow = '0 4px 16px rgba(0,0,0,0.15)';
        notification.style.zIndex = '2000';
        notification.style.animation = 'slideIn 0.3s ease-out';
        
        if (type === 'success') {
            notification.style.background = '#28a745';
            notification.style.color = 'white';
        } else if (type === 'error') {
            notification.style.background = '#dc3545';
            notification.style.color = 'white';
        } else if (type === 'warning') {
            notification.style.background = '#ffc107';
            notification.style.color = '#212529';
        }
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    },

    showLoading(elementId, show = true) {
        const element = document.getElementById(elementId);
        if (element) {
            element.style.display = show ? 'block' : 'none';
        }
    },

    showError(elementId, message) {
        const element = document.getElementById(elementId);
        if (element) {
            element.textContent = message;
            element.style.display = 'block';
        }
    },

    hideError(elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.style.display = 'none';
        }
    }
};

/**
 * Validação de Formulários
 */
const validator = {
    isValidEmail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email);
    },

    isNotEmpty(value) {
        return value && value.trim().length > 0;
    },

    isValidLength(value, maxLength) {
        return value.length <= maxLength;
    },

    sanitize(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }
};

/**
 * Formatadores
 */
const formatter = {
    truncate(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    },

    capitalize(text) {
        return text.charAt(0).toUpperCase() + text.slice(1).toLowerCase();
    },

    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('pt-BR');
    }
};

/**
 * Gerenciador de Estado Local
 */
const storage = {
    save(key, value) {
        try {
            localStorage.setItem(key, JSON.stringify(value));
            return true;
        } catch (error) {
            console.error('Error saving to localStorage:', error);
            return false;
        }
    },

    load(key) {
        try {
            const item = localStorage.getItem(key);
            return item ? JSON.parse(item) : null;
        } catch (error) {
            console.error('Error loading from localStorage:', error);
            return null;
        }
    },

    remove(key) {
        try {
            localStorage.removeItem(key);
            return true;
        } catch (error) {
            console.error('Error removing from localStorage:', error);
            return false;
        }
    }
};

/**
 * Debounce para otimização de eventos
 */
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

/**
 * Escape HTML para prevenir XSS
 */
function escapeHtml(text) {
    const map = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#039;'
    };
    return text.replace(/[&<>"']/g, m => map[m]);
}

/**
 * Função para confirmar ações críticas
 */
function confirmAction(message) {
    return confirm(message);
}

/**
 * Logger para desenvolvimento
 */
const logger = {
    log(message, data) {
        if (window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1') {
            console.log(`[NextJob] ${message}`, data || '');
        }
    },

    error(message, error) {
        console.error(`[NextJob Error] ${message}`, error || '');
    },

    warn(message, data) {
        console.warn(`[NextJob Warning] ${message}`, data || '');
    }
};

/**
 * Exportar APIs e utilitários para uso global
 */
window.NextJobApp = {
    api: {
        candidates: candidatesAPI,
        vacancies: vacanciesAPI,
        match: matchAPI
    },
    ui: ui,
    validator: validator,
    formatter: formatter,
    storage: storage,
    logger: logger,
    debounce: debounce,
    escapeHtml: escapeHtml,
    confirmAction: confirmAction
};

// Log de inicialização
logger.log('NextJob Application initialized successfully');
